package walletHup.palindrom;

import static org.junit.Assert.*;

import org.junit.Test;

public class PlaindromTest {

	@Test
	public void testIsPalindrome() {

		assertEquals(true, Plaindrom.isPalindrome("abba"));

	}
}
