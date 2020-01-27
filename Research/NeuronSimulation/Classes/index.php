<!DOCTYPE html>
<html>
<head>
    <title>NEURON Classes</title>
	<meta content="text/html;charset=UTF-8" />
    <link href="../style.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <h1 style="margin-bottom: 0px">
        NEURON Simulation</h1>
    <hr />
    <table style="border-style: none">
        <tr>
            <td style="border-style: none">
                <?php include("../navigationBar.php"); ?>
            </td>
            <td style="border-style: none">
                <h2>
                    Classes</h2>
    <table><tr><td><b>Built-in Object Type</b></td><td><b>Notes</b></td></tr><tr><td><b>Graph</b></td><td>&nbsp;</td></tr><tr><td>
        g1=new Graph()
        </td><td>Creates a new Graph object.</td></tr><tr><td>
        g1.size(xStart, xEnd, yStart, yEnd)
        </td><td>Sets x and y axes.</td></tr><tr><td>
        g1.beginline(&quot;Legend&quot;, color, thickness)
        </td><td>Color 2 is red.</td></tr><tr><td>
        {g1.line(x1,y1) g1.line(x2,y2)}
        </td><td>Draws a line from (x1,y1) to (x2,y2).</td></tr><tr><td>
        g1.flush()
        </td><td>Shows the line.</td></tr><tr><td><b>Vector</b></td><td>&nbsp;</td></tr><tr><td>
        vec1=new Vector()
        </td><td>Creates a new Vector object.</td></tr><tr><td>
        vec1.append(1,2,3)
        </td><td>Appends 1, 2, and 3 to vec1.</td></tr><tr><td>
        vec1.printf()
        </td><td>Prints the elements and the number of elements.</td></tr><tr><td>
        vec1.size()
        </td><td>Returns the number of elements.</td></tr><tr><td>
        vec1.sum()
        </td><td>Returns the sum.</td></tr><tr><td>
        vec1.mean()
        </td><td>Returns the mean.</td></tr><tr><td>
        vec1.add(2)
        </td><td>2 is added to each element.</td></tr><tr><td>
        vec1.mul(2)
        </td><td>Each element is multiplied by 2.</td></tr><tr><td>
        vec1.div(2)
        </td><td>Each element is divided by 2.</td></tr><tr><td>
        vec1.sub(2)
        </td><td>2 is subtraced from each element.</td></tr><tr><td>
        vec1.resize(size)
        </td><td>&nbsp;</td></tr><tr><td>
        vec1.x[0]
        </td><td>Represents the first element.</td></tr><tr><td>
        vec2.copy(vec1)
        </td><td>Copys vec1 into vec2.</td></tr><tr><td>
        vec1.add(vec2)
        </td><td>Addition. Element by element.</td></tr><tr><td>
        vec1.line(g1,1)
        </td><td>Plots elements as black lines in g1.</td></tr>
        <tr>
            <td>
                vec1.line(g1,vec2)
            </td><td>Plots vec1 against vec2 in g1.</td>
        </tr>
        <tr>
            <td>
                vec1.line(g1, dt, 2, 2)
            </td><td>&nbsp;</td>
        </tr>
        <tr><td>
            vec1.mark(g1,1)
            </td><td>Plots elements as crosses in g1.</td></tr><tr><td>
        vec1.vwrite(file1)
        </td><td>Writes vec1 to file1 in binary format.</td></tr><tr><td>
        vec1.vread(file1)
        </td><td>Reads data in file1 to vec1 in binary format.</td></tr><tr><td>
        fread()</td><td>&nbsp;</td></tr><tr><td>
        fwrite()</td><td>&nbsp;</td></tr><tr><td>
        scanf()</td><td>&nbsp;</td></tr><tr><td>
        scantil()</td><td>&nbsp;</td></tr><tr><td>
        vec1.fill(7)
        </td><td>Sets all elements to 7.</td></tr><tr><td>
        vec1.eq(vec2)
        </td><td>Examines whether vec1 and vec2 have the same values.</td></tr><tr><td>
        vec1.record(&amp;soma.v(0.5))
        </td><td>Records the voltage in the soma.</td></tr><tr><td>
        vec1.min()
        </td><td>Minimum</td></tr><tr><td>
        vec1.max()
        </td><td>Maximum</td></tr><tr><td>
        vec1.min_ind()
        </td><td>Index of the minimum</td></tr><tr><td>
        vec1.max_ind()
        </td><td>Index of the maximum</td></tr><tr><td>
        vec1.deriv(vec2,dt)
        </td><td>Saves derivative of vec2 to vec1.</td></tr><tr><td>
        vec1.interpolate()</td><td>&nbsp;</td></tr><tr><td><b>File</b></td><td>&nbsp;</td></tr><tr><td>
        file1=new File()
        </td><td>Creates a new File object.</td></tr><tr><td>
        file1.wopen(&quot;Test.dat&quot;)
        </td><td>Opens Test.dat for writing data.</td></tr><tr><td>
        file1.ropen(&quot;Test.dat&quot;)
        </td><td>Opens Test.dat for reading data.</td></tr><tr><td>
        file1.aopen(&quot;Test.dat&quot;)
        </td><td>Opens Test.data for appending data.</td></tr><tr><td>
        file1.close()
        </td><td>Closes the file.</td></tr><tr><td><b>List</b></td><td>&nbsp;</td></tr><tr><td>
        list1=new List()
        </td><td>Creates a new List object.</td></tr><tr><td>
        list1.append(vec1)
        </td><td>Appends vec1 to list1.</td></tr><tr><td>
        list1.count()
        </td><td>Returns the count of elements.</td></tr><tr><td>
        list1.object(0)
        </td><td>Indicates the first object.</td></tr><tr><td>
        list1.remove(0)
        </td><td>Removes the first object.</td></tr><tr><td><b>IClamp</b></td><td><b>Current Clamp</b></td></tr><tr><td>
        soma stim1=new IClamp(0.5)
        </td><td>Inserts an electrode to the middle of the soma.</td></tr><tr><td>
        stim1.amp
        </td><td>Amplitude</td></tr><tr><td>
        stim1.dur
        </td><td>Duration</td></tr><tr><td><b>SEClamp</b></td><td><b>Single Electrode Voltage Clamp</b></td></tr><tr><td>rs</td><td>Series resistance</td></tr><tr><td>
        dur1, amp1</td><td>Duration 1 (ms), amplitude 1 (mV)</td></tr><tr><td>dur2, amp2</td><td>Duration 2 (ms), amplitude 2 (mV)</td></tr><tr><td>dur3, amp3</td><td>
        Duration 3 (ms), amplitude 3 (mV)</td></tr>
        
            </table>
            </td>
        </tr>
    </table>
    <hr />
</body>
</html>
