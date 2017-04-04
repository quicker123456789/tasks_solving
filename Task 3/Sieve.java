/**
eratosthene sieve prime java
*/

import java.util.Arrays;

public class Sieve{

public static boolean fillSieve(int n) {	
	boolean[] primes=new boolean[n+1];
	Arrays.fill(primes,true);
	primes[0]=primes[1]=false;
	for (int i=2;i<primes.length;i++) {
		if(primes[i]) {
			for (int j=2;i*j<primes.length;j++) 
				primes[i*j]=false;
          
		}
	}
	return primes[n];
}

 
	public static void main (String[] args){
		System.out.print(fillSieve(3197));
	}
}