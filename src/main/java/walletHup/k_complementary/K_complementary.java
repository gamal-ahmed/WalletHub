package walletHup.k_complementary;

import java.util.HashMap;
import java.util.Set;

public class K_complementary {
	public static int findKComplLinearTimeLinearSpace(int[] arr, int K) {
		int count = 0;

		// Let's store every item in a hashmap, key is the array element
		// value is the number of time the value occurs in the array
		HashMap<Integer, Integer> occurrencies = new HashMap<Integer, Integer>();

		// Time: O(N)
		// HashMap has constant access time
		for (int i : arr) {
			if (occurrencies.get(i) == null)
				occurrencies.put(i, 1);
			else
				occurrencies.put(i, occurrencies.get(i) + 1);
		}

		// Now let's traverse the hashmap and find out if for each key
		// one or more complementary values exists in the HashMap
		// Time: O(N)
		Set<Integer> keys = occurrencies.keySet();
		for (Integer key : keys) {
			int needed = K - key;
			if (occurrencies.containsKey(needed)) {
				count += occurrencies.get(key) * occurrencies.get(needed);
			}
		}

		return count;
	}
}
