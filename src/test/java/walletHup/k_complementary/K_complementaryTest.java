package walletHup.k_complementary;

import static org.junit.Assert.*;

import org.junit.Test;

public class K_complementaryTest {

	@Test
	public void testFindKComplLinearTimeLinearSpace() {

	
		int [] numbers={2, 5, -1, 6, 10, -2};
		K_complementary.findKComplLinearTimeLinearSpace(numbers, 4);
	}

}
