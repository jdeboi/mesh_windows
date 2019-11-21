import java.lang.Math;
import java.util.Arrays;
import java.time.LocalDateTime;
 
class variable{
  int num;
  double value;
  double[] iterations;
  
  variable(int n1){
    num = n1;
    iterations = new double[6];
  }
  

  String[] calculateVariable(double T, String [] lines){
    
    num = getVariable(lines[0]);
    
    //printwriter code for testing
    PrintWriter output;
    output = createWriter("testing.txt"); 
    
    //output.println("Hello World");
    
    
    for (int i = 0; i < 6; i++){
      if (lines != null && lines.length > 0){ //checking for text in array because of earth exception
    
        double[] myTerms;
        myTerms = gatherTerms(output, T, lines); //send it starting at header line
        double total = 0;

        for (int j = 0; j<myTerms.length; j++){
        total = total + myTerms[j];
       } //adding terms  = single iteration 
 
      iterations[i] = total;  
      
      
      lines = Arrays.copyOfRange(lines, myTerms.length + 1, lines.length);
      
      
      }
    } //iterations array full
    
    value = 0;
    
    for(int i = 0; i<6; i++){ //calculation of variable using iterations array
     if (iterations[i] != 0){
       output.println(iterations[i]);
      value += iterations[i] * Math.pow(T, i);
     }
    }

    int i = 0; 
    if (num != 3){//so that it doesn't iterate past end of string array
      while (getVariable(lines[i]) != num + 1) {//iterating to next variable 
        i = i + getNumTerms(lines[i]) + 1;
      }
    }
    
    output.flush(); // Writes the remaining data to the file
    output.close();
    return Arrays.copyOfRange(lines, i, lines.length);
  }

  double [] gatherTerms(PrintWriter output, double T, String [] lines){
    
    double[] terms;
    output.println(lines[0]);
    int numTerms = getNumTerms(lines[0]);
    terms = new double[numTerms];
  
    for (int i = 1; i<=terms.length; i++){
      //output.println(lines[i]);
      terms[i-1] = calculateTerm(output, T, lines[i]); //put read term coefs and calculate in same function 

    } 

    
    return terms;
    
  }
  
  double calculateTerm(PrintWriter output, double T, String line){
    
    int i = 84;
    int aLen = 14;
    int bLen = 13;
    int cLen = 19;
    
    if (new Character(line.charAt(i)).equals(' ') == true){
      aLen--;
      i++;
    }
    i--;
    
    double coef1 = Double.parseDouble(line.substring(i, i + aLen));
    i = i + aLen + 1;
    
    double coef2 = Double.parseDouble(line.substring(i, i + bLen));
    i = i + bLen;
    
    while (new Character(line.charAt(i)).equals(' ') == true){
      cLen--;
      i++;
    }
    
  
    
    double coef3 = Double.parseDouble(line.substring(i, i + cLen));
    
    double termVal = coef1 * Math.cos(coef2 + coef3 * T);
    output.println(coef1+ " " + coef2 + " " + coef3);
    
    return termVal;
  }
  

  int getNumTerms(String line){
 
    int i = 60;
    int j = 0;
    char[] word;
    word = new char[4];
    int numTerms;
    int numTermLen = 0;
    
   
    while(new String(word).compareTo("TERM") != 0){
      for (j=0; j<4; j++){
        
        word[j] = line.charAt(i + j);
      }
      i++;
    }
    j = i - 3;

    while( new Character(line.charAt(j)).equals(' ') == false){
      
      numTermLen++;
      j--;
    }

    j++;

    numTerms = Integer.parseInt(line.substring(j, j + numTermLen));

    return numTerms;
  }
  
 int getVariable(String line){
   int i = 0;
   char[] word;
   word = new char[4];
   int variableNum;
   

   while (new String(word).compareTo("ABLE") != 0){
     for (int j=0; j<4; j++){
       word[j] = line.charAt(j + i);
     }
     i++;
   }
   
   variableNum = Character.getNumericValue(line.charAt(i + 4));
   return variableNum;
 }
    
 int getIteration(String line){
   int i = 0;
   char[] word;
   word = new char[4];
   int iterationNum;
   
   
   while (new String(word).compareTo("*T**") != 0){
     for (int j=0; j<4; j++){
       word[j] = line.charAt(j + i);
     }
     i++;
   }
   
   iterationNum = Character.getNumericValue(line.charAt(i + 3));
   return iterationNum;
 }
 
}


    
    
