package walletHup.palindrom;

/**
 * Write an efficient algorithm to check if a string is a palindrome. A string
 * is a palindrome if the string matches the reverse of string. Example: 1221 is
 * a palindrome but not 1121.
 **/
public class Plaindrom {

	static boolean isPalindrome(String s) {
		int n = s.length();
		for (int i = 0; i < (n / 2); ++i) {
			if (s.charAt(i) != s.charAt(n - i - 1)) {
				return false;
			}
		}

		return true;
	}

}
