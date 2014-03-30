function factorial(n) {
    
    // base case where 1! = 1
    if (n == 1) {
        return 1;
   
   // recursive case where n! = n * (n-1)!
   } else {
        return n * factorial(n-1);
    }
    
}