import java.util.*;
import java.io.*;
import java.math.*;
public class Day24 {
  public static Map<String, BigInteger> execute(List<String> instructions, List<Integer>input) {
    // input = input.dup
    Map<String, BigInteger> vals = new HashMap<>();
    vals.put("w", BigInteger.ZERO);
    vals.put("x", BigInteger.ZERO);
    vals.put("y", BigInteger.ZERO);
    vals.put("z", BigInteger.ZERO);
    int inputIndex = 0;

    for (String inst: instructions) {
      String[] i = inst.split(" ");
      String cmd = i[0];
      String a = i[1];
      String b = null;
      BigInteger bVal = null;
      if (i.length > 2) {
        b = i[2];
        if (vals.containsKey(b)) {
          bVal = vals.get(b);
        } else {
          bVal = new BigInteger(b);
        }
      }

      switch(cmd) {
        case "inp":
          vals.put(a, BigInteger.valueOf(input.get(inputIndex++)));
          break;
        case "add":
          vals.put(a, vals.get(a).add(bVal));
          break;
        case "mul":
          vals.put(a, vals.get(a).multiply(bVal));
          break;
        case "div":
          vals.put(a, vals.get(a).divide(bVal));
          break;
        case "mod":
          vals.put(a, vals.get(a).mod(bVal));
          break;
        case "eql":
          vals.put(a, vals.get(a) == bVal ? BigInteger.ONE : BigInteger.ZERO);
          break;
        default:
          throw new IllegalArgumentException("Invalid cmd:" + cmd);
      }
    }
    return vals;
  }

  public static List<String> readFile(String fileName) throws IOException{
    List<String> rv = new ArrayList<>();
    BufferedReader br = new BufferedReader(new FileReader(fileName));
    String line;
    while((line = br.readLine()) != null) {
      rv.add(line);
    }
    return rv;
  }

  public static void main(String[] args) throws Exception{
    List<String> instructions = readFile("day24.txt");
    BigInteger cnt = new BigInteger("99999999999999");
    while (!cnt.equals(BigInteger.ZERO) ) {
      List<Integer> digits = new ArrayList<>();
      for (char c : cnt.toString().toCharArray()) {
        digits.add(c - '0');
      }
      while(digits.size() < 14) {
        digits.add(0, 0);
      }

      Map<String, BigInteger> vals = execute(instructions, digits);
      // System.out.println(vals);
      cnt = cnt.subtract(BigInteger.ONE);
      if (cnt.mod(new BigInteger("1000")) == BigInteger.ZERO) {
        System.out.print(".");
      }

    }
  }
}