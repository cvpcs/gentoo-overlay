/**
 * 
 */
package leds.modules;

import leds.ExtProperties;
import leds.Canvas;
import java.io.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * This module displays the details of a running emerge.
 * 
 * @author zeande
 */
public class EmergeLog extends BaseModule {
	int height = 0;
	int width = 0;
	int x = 0;
	int y = 0;

	final String success = "Emerge finished";
	final String failure = "Emerge failed";

	String pkg = "Package";
	String versionTo = "";
	String versionFrom = "";
	String status = "";
	String progress = " ";

	private final Pattern progressPattern = Pattern
			.compile("([0-9]+) of ([0-9]+)");
	private final Pattern pkgPattern = Pattern
			.compile("[0-9]+\\) ([a-zA-Z /]+) \\(([a-zA-Z0-9/\\.-]+)::");
	private final Pattern versionPattern = Pattern
			.compile("([a-zA-Z0-9/-]+)-([0-9]+[\\.]{0,1}[r0-9\\.]*)");

	boolean finished = true;
	long lastChanged = 0;

	final int finishedThreshold = 30000;

	/*
	 * (non-Javadoc)
	 * 
	 * @see leds.Module#getHeight()
	 */
	@Override
	public int getHeight() {
		return this.height;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see leds.Module#getWidth()
	 */
	@Override
	public int getWidth() {
		return this.width;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see leds.Module#init(leds.ExtProperties, int, int)
	 */
	@Override
	public void init(final ExtProperties config, final int xStart,
			final int yStart) {
		super.init(config, xStart, yStart);
		checkLog();
	}

	/**
	 * Retrieves a specified number of lines from the end of the emerge log
	 * file.
	 * 
	 * @param lines
	 *            An integer parameter that specifies the number of lines to
	 *            retrieve from the end of the emerge log file.
	 * @return An array that contains one element for each line from the end of
	 *         the emerge log file.
	 * 
	 */
	private String[] getLast(int lines) {

		String[] out = new String[lines];
		Runtime run = Runtime.getRuntime();
		Process pr = null;

		// We only want important stuff
		String filter = "\"===|\\*\\*\\*\"";

		try {
			String command = "tail -" + (lines * 2 + 10)
					+ " /var/log/emerge.log | egrep " + filter + "|tail -"
					+ lines;
			System.out.println("Executing command: " + command);
			pr = run.exec(new String[] { "bash", "-c", command });
		} catch (IOException e) {
			e.printStackTrace();
		}
		try {
			pr.waitFor();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		BufferedReader buf = new BufferedReader(new InputStreamReader(pr
				.getInputStream()));
		String line = "";
		try {
			for (int i = 0; (line = buf.readLine()) != null && i < lines; i++)
				out[i] = line;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return out;
	}

	/**
	 * Updates instance variables to be in accordance with the currently
	 * emerging package.
	 * 
	 * @return A boolean value that indicates whether there is an emerge in
	 *         progress.
	 * @TODO  - Perhaps use a bash command to parse the output rather than having java do it.
	 * 		  - Make the parsing more robust.
	 */
	private boolean checkLog() {
		int length = 6;
		String[] log = getLast(length);
		if (log[length - 1].indexOf("terminating") != -1) {
			finished = true;
			long tempTime = Math.max(lastChanged, Integer
					.parseInt(log[length - 1].split(":")[0]));
			if (System.currentTimeMillis() - tempTime > finishedThreshold)
				return false;
			status = (log[length - 2].indexOf("unsuccess") != -1) ? failure
					: success;
		} else {
			finished = false;
			lastChanged = System.currentTimeMillis();
			String line = log[length - 1];
			Matcher matcher = progressPattern.matcher(line);
			if (matcher.find())
				progress = matcher.group(1) + " of " + matcher.group(2);

			matcher = pkgPattern.matcher(line);
			if (matcher.find()) {
				status = matcher.group(1);
				pkg = matcher.group(2);
				matcher = versionPattern.matcher(pkg);
				if (matcher.find()) {
					pkg = matcher.group(1);
					versionTo = matcher.group(2);
				}
			}
			versionFrom = "1.0";
		}
		return true;
	}

	/**
	 * Draws the appropriate text to the oled screen.
	 * @TODO Make this better
	 */
	public boolean draw(final Canvas c) {
		if (!checkLog())
			return false;

		if (this.height == 0)
			this.height = c.getTextHeight() - 2;

		if (this.width == 0)
			this.width = 100;
		if (finished) {
			c.drawString(status, this.x, this.height);
		} else {
			c.drawString("Emerging: " + progress, this.x, this.height);
			c.drawString(pkg.substring(0, Math.min(pkg.length(), 28)), this.x,
					this.height * 2);
			c.drawString("State: " + status, this.x, this.height * 3);
			c.drawString("Version:" + versionTo, this.x, this.height * 4);
		}
		return true;
	}
}
