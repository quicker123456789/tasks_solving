import java.io.*;

public class Program {

    public static void main (String args[]){
        Tests.BasicTests();
        Tests.TestsWithError();
        Tests.BasicTestsWithFile();
    }
}

class MathParser {
    private static final String operators = "+-/*";

    public double parseAndCompute(File file) {
        MathUnit mathUnit = new MathUnit();
        BufferedReader br = null;
        StringBuilder numberBuilder = new StringBuilder();

        int c;
        try {
            br = new BufferedReader (new FileReader(file));
            while((c=br.read())!=-1){
                processSymbol((char)c, mathUnit, numberBuilder);
            }
			br.close();
        } catch (FileNotFoundException e) {
            throw new Error("File not found");
        } catch (IOException e) {
            try { br.close(); } catch (Exception ex) {}
            throw new Error("Read file error");
        }

        mathUnit.addValue( parseNumber( numberBuilder.toString().trim() ));
        return mathUnit.getResult();
    }

    public double parseAndCompute(String data) {
        return parseAndCompute(data.toCharArray());
    }

    public double parseAndCompute(char[] data) {
        MathUnit mathUnit = new MathUnit();
        StringBuilder numberBuilder = new StringBuilder();

        for (char symbol: data) {
            processSymbol(symbol, mathUnit, numberBuilder);
        }
        mathUnit.addValue( parseNumber( numberBuilder.toString().trim() ));
        return mathUnit.getResult();
    }

    private void processSymbol(char symbol, MathUnit mathUnit, StringBuilder numberBuilder) {
        if (operators.indexOf(symbol) != -1) {
            mathUnit.addValue( parseNumber( numberBuilder.toString().trim() ));
            mathUnit.addOperator(symbol);
            numberBuilder.setLength(0);
        } else {
            numberBuilder.append(symbol);
        }
    }

    private double parseNumber(String s) {
        if (s.startsWith(".")) throw new Error("Incorrect data, number starts from dot");

        try {
            return Double.parseDouble(s);
        } catch (Exception ex) {
            throw new Error("Incorrect data, parse error");
        }
    }
}

class MathUnit {
    private static final char SUM = '+';
    private static final char SUBSTR = '-';
    private static final char DIV = '/';
    private static final char MULT = '*';

    private double[] values;
    private char[] operators;

    private byte nextValueIdx;
    private byte nextOperatorIdx;

    MathUnit(){
        init();
    }

    public double getResult() {
        if (nextOperatorIdx != 0) compute();
        return values[0];
    }

    public void addValue(double value) {
        values[nextValueIdx] = value;
        nextValueIdx++;

        computeIfAllDataExist();
    }

    public void addOperator(char operator) {
        operators[nextOperatorIdx] = operator;
        nextOperatorIdx++;

        computeIfAllDataExist();
    }

    private void computeIfAllDataExist() {
        if (nextValueIdx == values.length && nextOperatorIdx == operators.length) {
            compute();
        }
    }

    private void compute() {
        if (operators[0] == MULT) {
            reinit(values[0] * values[1], values[2], operators[1]);
            return;
        }

        if (operators[0] == DIV) {
            reinit(safeDiv(values[0], values[1]), values[2], operators[1]);
            return;
        }

        if (operators[1] == MULT) {
            reinit(values[0], values[1] * values[2], operators[0]);
            return;
        }

        if (operators[1] == DIV) {
            reinit(values[0], safeDiv(values[1], values[2]), operators[0]);
            return;
        }

        if (operators[0] == SUM) {
            reinit(values[0] + values[1], values[2], operators[1]);
            return;
        }

        if (operators[0] == SUBSTR) {
            reinit(values[0] - values[1], values[2], operators[1]);
            return;
        }
    }

    private void init() {
        values = new double[3];
        operators = new char[2];

        nextValueIdx = 0;
        nextOperatorIdx = 0;
    }

    private void reinit(double initValue1, double initValue2, char initOperator) {
        init();

        addValue(initValue1);
        addOperator(initOperator);
        addValue(initValue2);
    }

    private double safeDiv(double arg1, double arg2) {
        if (arg2 == 0) throw new Error("Divide by zero");
        return arg1 / arg2;
    }
}

class Tests {
    public static void BasicTests () {
        Test("5+10*25 - 70 / 35", 253);
        Test("5+10*25 - 70 / 35 +        5+10*25 - 70 / 35 + 0000.00500", 506.005);
        Test("5+10+20*25*6 - 70.0000 / 35 / 2 + 4", 3018);
    }

    public static void BasicTestsWithFile () {
        Test(new File("testData_253.txt"), 253);
        Test(new File("testData_506.005.txt"), 506.005);
        Test(new File("testData_3018.txt"), 3018);
    }

    public static void TestsWithError() {
        TestWithError("0/0", "Divide by zero");
        TestWithError("5+ -5", "Incorrect data, parse error");
        TestWithError("(5+3) * 2", "Incorrect data, parse error");
        TestWithError("3,3 + 0.5", "Incorrect data, parse error");
        TestWithError("1 000 + 0.5", "Incorrect data, parse error");
        TestWithError(".3 + 5", "Incorrect data, number starts from dot");
    }

    public static void TestWithError(String data, String expectedErrorMessage) {
        MathParser parser = new MathParser();
        String errorMessage = "";
        try {
            parser.parseAndCompute(data);
        }catch (Error e) {
            errorMessage = e.getMessage();
        }
        assert ( errorMessage == expectedErrorMessage ) : "Expected error with message: '" + expectedErrorMessage
                + "', result: '" + errorMessage + "'";
    }

    public static void Test(String data, double expectedResult) {
        MathParser parser = new MathParser();
        double result = parser.parseAndCompute(data);
        assert ( result == expectedResult ) : "Expected: " + expectedResult + ", result: " + result;
    }

    public static void Test(File file, double expectedResult) {
        MathParser parser = new MathParser();
        double result = parser.parseAndCompute(file);
        assert ( result == expectedResult ) : "Expected: " + expectedResult + ", result: " + result;
    }
}