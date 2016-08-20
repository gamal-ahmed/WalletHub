package walletHup.palindrom;

import org.apache.log4j.Logger;

import walletHup.k_complementary.K_complementary;

/**
 * Write an efficient algorithm to check if a string is a palindrome. A string
 * is a palindrome if the string matches the reverse of string. Example: 1221 is
 * a palindrome but not 1121.
 **/
public class Plaindrom {
	final static Logger logger = Logger.getLogger(K_complementary.class);

	static boolean isPalindrome(String s) {
		if (logger.isInfoEnabled()) {
			logger.info(" Plaindrom ... ");
		}
		int n = s.length();
		for (int i = 0; i < (n / 2); ++i) {
			if (s.charAt(i) != s.charAt(n - i - 1)) {
				return false;
			}
		}

		return true;
	}

}
