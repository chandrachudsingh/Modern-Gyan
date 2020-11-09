<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Faculty Preferences | Modern-Gyan</title>

    <link rel="stylesheet" href="FacultyPreferences.css">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

    <script>
        function DisableFields() 
        {
            for(var i=2; i <document.getElementsByClassName("TimeSlots").length-1; i++)
            {
                document.getElementsByClassName("TimeSlots").item(i).disabled = "disabled";
                document.getElementsByClassName("TimeSlots").item(i).style.cursor = "not-allowed";
                document.getElementsByClassName("TimeSlots").item(i+1).disabled = "disabled";
                document.getElementsByClassName("TimeSlots").item(i+1).style.cursor = "not-allowed";
            }

            for(var i=1; i < document.getElementsByName("cbSubName").length; i++)
            {
                document.getElementsByName("cbSubName").item(i).disabled = "disabled";
                document.getElementsByName("cbSubName").item(i).style.cursor = "not-allowed";
            }
        }

        function EnableSlots(n) 
        {
            for(var i=n; i < document.getElementsByClassName("TimeSlots").length-3; i+=2)
            {
                if(document.getElementsByClassName("TimeSlots").item(i).value != "" && document.getElementsByClassName("TimeSlots").item(i+1).value != "")
                {
                    document.getElementsByClassName("TimeSlots").item(i+2).disabled = "";
                    document.getElementsByClassName("TimeSlots").item(i+2).style.cursor = "pointer";
                    document.getElementsByClassName("TimeSlots").item(i+3).disabled = "";
                    document.getElementsByClassName("TimeSlots").item(i+3).style.cursor = "pointer";
                    break;
                }
            }
        }

        function EnableSubjects(n)
        {
            for(var i=n; i < document.getElementsByName("cbSubName").length-1; i++)
            {
                if(document.getElementsByName("cbSubName").item(i).value != "")
                {
                    document.getElementsByName("cbSubName").item(i+1).disabled = "";
                    document.getElementsByName("cbSubName").item(i+1).style.cursor = "pointer";
                    break;
                }    
            }
        }
    </script>
</head>
<body onload="DisableFields()">

    <span id="SiteName" title="Modern-Gyan"> Modern-Gyan </span>
    <form action="FacultyPreferencesBack.jsp" method="POST">
        <h4 id="WorkHead">Enter your preferences. You can change it further..</h4>

        <%
            int i=0;
            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                    //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                                
                stmt.execute("Use Modern_Gyan_Db");
                stmt.executeUpdate("Create table if not exists SubjectTb(topic_id int auto_increment primary key,"
                        + "topic_code varchar(50), topic_name varchar(50), topic_duration int, subject_code varchar(50))");

                ResultSet rs=stmt.executeQuery("select count(*) from SubjectTb");
                String opt="";
                while(rs.next())
                    i = rs.getInt(1);

                con.close();
            }
            catch (ClassNotFoundException e) 
            {
                out.println("ClassNotFoundException caught: "+e.getMessage());
            }
            catch (SQLException e) 
            {
                out.println("SQLException caught: "+e.getMessage());
            }

            String[] subject_name = new String[i];
        %>

        
        <fieldset id="Subjects">
            <legend> Enter preferred subjects </legend>

            <table>
                <tr>
                    <th> <label for="sub_name1"> Subject 1 : </label>     
                    <td> <select name="cbSubName" id="sub_name1" onchange="EnableSubjects(0)">
                        <option>Select subject</option>
                        <%
                            i=0;
                            try 
                            {
                                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                                    //to build connection between Java and database 
                                Statement stmt=con.createStatement();  //create statement class object
                                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                                        //"if not exists" used because of database not created multiple times(error)
                                
                                stmt.execute("Use Modern_Gyan_Db");

                                ResultSet rs=stmt.executeQuery("select subject_name from SubjectTb");
                                while(rs.next())
                                {
                                    subject_name[i]=rs.getString("subject_name");
                                    out.print("<option value='"+subject_name[i]+"'>"+subject_name[i]+"</option>");
                                    i++;
                                }

                                con.close();
                            }
                            catch (ClassNotFoundException e) 
                            {
                                out.println("ClassNotFoundException caught: "+e.getMessage());
                            }
                                catch (SQLException e) 
                            {
                                out.println("SQLException caught: "+e.getMessage());
                            }
                        %>
                    </select> </td>

                    <th> <label for="sub_name2"> Subject 2 : </label>
                    <td> <select name="cbSubName" id="sub_name2" onchange="EnableSubjects(1)">
                        <option>Select subject</option>
                        <%
                            for(i=0; i<subject_name.length; i++)
                                out.print("<option value='"+subject_name[i]+"'>"+subject_name[i]+"</option>");
                        %>
                    </select> </td>

                    <th> <label for="sub_name3"> Subject 3 : </label>
                    <td> <select name="cbSubName" id="sub_name3" onchange="EnableSubjects(2)">
                        <option>Select subject</option>
                        <%
                            for(i=0; i<subject_name.length; i++)
                                out.print("<option value='"+subject_name[i]+"'>"+subject_name[i]+"</option>");
                        %>
                    </select> </td>
                </tr>

                <tr>
                    <th> <label for="sub_name4"> Subject 4 : </label> </th>
                    <td> <select name="cbSubName" id="sub_name4" onchange="EnableSubjects(3)">
                        <option>Select subject</option>
                        <%
                            for(i=0; i<subject_name.length; i++)
                                out.print("<option value='"+subject_name[i]+"'>"+subject_name[i]+"</option>");
                        %>
                    </select> </td>

                    <th> <label for="sub_name5"> Subject 5 : </label> </th>
                    <td> <select name="cbSubName" id="sub_name5" onchange="EnableSubjects(4)">
                        <option>Select subject</option>
                        <%
                            for(i=0; i<subject_name.length; i++)
                                out.print("<option value='"+subject_name[i]+"'>"+subject_name[i]+"</option>");
                        %>
                    </select> </td>
                    
                    <th> <label for="sub_name6"> Subject 6 : </label> </th>
                    <td> <select name="cbSubName" id="sub_name6" onchange="EnableSubjects(5)">
                        <option>Select subject</option>
                        <%
                            for(i=0; i<subject_name.length; i++)
                                out.print("<option value='"+subject_name[i]+"'>"+subject_name[i]+"</option>");
                        %>
                    </select> </td>
                </tr>
            </table>     
        </fieldset>

        <fieldset id="Slots">
            <legend> Enter preferred time slots </legend>

            <table>
                <tr>
                    <th> Slot 1 : </th>
                    <td> <input type="time" name="timeSlotfrom" id="slot1from" class="TimeSlots" onchange="EnableSlots(0)"> to
                        <input type="time" name="timeSlotto" id="slot1to" class="TimeSlots" onchange="EnableSlots(0)"> </td>
                    <th> Slot 2 : </th>
                    <td> <input type="time" name="timeSlotfrom" id="slot2from" class="TimeSlots" onchange="EnableSlots(2)"> to
                        <input type="time" name="timeSlotto" id="slot2to" class="TimeSlots" onchange="EnableSlots(2)"> </td>
                    <th> Slot 3 : </th>
                    <td> <input type="time" name="timeSlotfrom" id="slot3from" class="TimeSlots" onchange="EnableSlots(4)"> to    
                        <input type="time" name="timeSlotto" id="slot3to" class="TimeSlots" onchange="EnableSlots(4)"> </td>
                <tr>
                </tr>
                    <th> Slot 4 : </th>
                    <td> <input type="time" name="timeSlotfrom" id="slot4from" class="TimeSlots" onchange="EnableSlots(6)"> to
                        <input type="time" name="timeSlotto" id="slot4to" class="TimeSlots" onchange="EnableSlots(6)"> </td>
                    <th> Slot 5 : </th>
                    <td> <input type="time" name="timeSlotfrom" id="slot5from" class="TimeSlots" onchange="EnableSlots(8)"> to
                        <input type="time" name="timeSlotto" id="slot5to" class="TimeSlots" onchange="EnableSlots(8)"> </td>
                    <th> Slot 6 : </th>
                    <td> <input type="time" name="timeSlotfrom" id="slot6from" class="TimeSlots" onchange="EnableSlots(10)"> to
                        <input type="time" name="timeSlotto" id="slot6to" class="TimeSlots" onchange="EnableSlots(10)"> </td>
                </tr>
            </table>
        </fieldset>

        <fieldset id="platforms">
            <legend> Choose from available platforms </legend>

            <table width="1000px" height="40px">
                <tr>
                    <td> <input type="checkbox" id="platform1" name="cbPlatforms" value="Google meet"> <label for="platform1"> Google meet </label> </td>
                    <td> <input type="checkbox" id="platform2" name="cbPlatforms" value="Zoom app"> <label for="platform2"> Zoom app </label> </td>
                    <td> <input type="checkbox" id="platform3" name="cbPlatforms" value="Cisco Webex"> <label for="platform3"> Cisco Webex </label> </td>
                    <td> <input type="checkbox" id="platform4" name="cbPlatforms" value="Jio meet"> <label for="platform4"> Jio meet </label> </td>
                </tr>
            </table>
        </fieldset>

        <div id="SubmitBtn"> <input type="submit" name="sbSubmit" value="Submit"> </div>
    </form>
</body>
</html>