import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class Program {
    public static void main (String args[]){
        if (args == null || args.length != 4) {
            endWithError("Wrong arguments number!");
        }

        String inFilePath = args[0];
        String outFilePath = args[1];
        LineType lineType = null;
        SortDir sortDir = null;

        try {
            lineType = Converter.strToLineType(args[2]);
            sortDir = Converter.strToSortDir(args[3]);
        }
        catch (Error e) {
            endWithError(e.getMessage());
        }

        //read inFile
        List<String> inValues = null;
        try {
            Reader reader = new Reader(inFilePath);
            inValues = reader.ReadFileToArray();
        } catch (FileNotFoundException e) {
            endWithError("Wrong inFile path!");
        } catch (IOException e) {
            endWithError("inFile read error!");
        }

        //sort
        Sorter sorter = new Sorter(lineType,sortDir);
        List<String> result = new ArrayList<String>();
        try {
            result = sorter.insertionSort(inValues);
        }catch (Error e) {
            endWithError(e.getMessage());
        }

        //write result to outFile
        try {
            Writer writer = new Writer(outFilePath);
            writer.Write(result);
        } catch (IOException e) {
            endWithError("Save to outFile error!");
        }
    }

    static void endWithError(String error) {
        System.out.printf("Error: %s \n", error);
        System.out.println("");

        System.out.println("Usage: infile outfile character-type(-i int/-s str) sort-direction(-a asc/-d desc)");
        System.out.println("Example: file1.txt file2.txt -i -a");

        System.exit(1);
    }
}

class Reader {
    BufferedReader buf;

    public Reader(String filepath) throws FileNotFoundException {
        buf = new BufferedReader(new FileReader(filepath));
    }

    public List<String> ReadFileToArray() throws IOException {
        String lineText;
        ArrayList<String> list = new ArrayList<String>();

        while ((lineText = buf.readLine()) != null) {
            list.add(lineText);
        }
        buf.close();

        return list;
    }
}

class Writer {
    BufferedWriter buf;

    public Writer(String filepath) throws IOException {
        buf = new BufferedWriter(new FileWriter(filepath));
    }

    public void Write(List<String> toWrite) throws IOException {
        for (String s : toWrite) {
            buf.write(s + "\n");
        }
        buf.flush();
        buf.close();
    }
}

class Sorter {
    public LineType lineType;
    public SortDir sortDir;

    public Sorter(LineType lType, SortDir sDir) {
        lineType = lType;
        sortDir = sDir;
    }

    public List<String> insertionSort(List<String> input) throws Error {
        String temp;

        for (int i = 1; i < input.size(); i++) {
            for(int j = i ; j > 0 ; j--){
                if( (sortDir == SortDir.Ask && compare(input.get(j-1), input.get(j)))
                ||  (sortDir == SortDir.Desk && compare(input.get(j), input.get(j-1)))) {
                    temp = input.get(j);
                    input.set(j, input.get(j-1));
                    input.set(j-1, temp);
                }
            }
        }
        return input;
    }

    Boolean compare(String a, String b) throws Error {
        switch (lineType) {
            case String: return a.compareTo(b) > 0;
            case Int: try {
                return Integer.parseInt(a) > Integer.parseInt(b);
            } catch (NumberFormatException e) {
                throw new Error("Incorrect data format! Expected: integer, values: '" + a + "', '" + b + "'");
            }
            default: throw new Error("This character-type is not supported!");
        }
    }
}

class Converter {
    static SortDir strToSortDir(String s) throws Error {
        switch (s) {
            case "-a": return SortDir.Ask;
            case "-d": return SortDir.Desk;
            default: throw new Error("Wrong sort-direction!");
        }
    }

    static LineType strToLineType(String s) throws Error {
        switch (s) {
            case "-i": return LineType.Int;
            case "-s": return LineType.String;
            default: throw new Error("Wrong character-type!");
        }
    }
}

enum SortDir {
    Ask, Desk;
}

enum LineType {
    Int, String;
}