<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Faculty Home | Modern-Gyan</title>
    <link rel="stylesheet" href="FacultyHome.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/95d52dbbb6.js" crossorigin="anonymous"></script>

    <script>
        function FirstLook()
        {
            document.getElementsByClassName("CoursesLink").item(0).style.borderBottom = "4px solid rgb(72, 72, 204)";
        }

        function LinkSelected(n) 
        {
            document.getElementsByClassName("CoursesLink").item(n).style.borderBottom = "4px solid rgb(72, 72, 204)"; 
            for(var i=0; i<document.getElementsByClassName("CoursesLink").length; i++)
            {
                if(i!=n)
                   document.getElementsByClassName("CoursesLink").item(i).style.borderBottom = "4px solid white";
            }
        }
    </script>
</head>

<body onload="FirstLook()">

    <%
        if((String) application.getAttribute("session_faculty") == null)
        {
            %><script> 
                alert("You just logged out, Login to continue.."); 
                location.assign("../LoginPage.jsp");
            </script><%
        }
    %>

    <%-- Site Header --%>
    <jsp:include page="FacultySiteHeader.jsp"/>

    <%-- Courses iframe panel --%>
    <div id="IframePanel">
        <div id="IframeSrcPanel"> 
            <a href="FacultyUpcomingCourse.jsp" target="OurIframe" class="CoursesLink" onclick="LinkSelected(0)"> Upcoming </a>
            <a href="FacultyOngoingCourse.jsp" target="OurIframe" class="CoursesLink" onclick="LinkSelected(1)"> In Progress </a>
            <a href="FacultyCompletedCourse.jsp" target="OurIframe" class="CoursesLink" onclick="LinkSelected(2)"> Completed </a>
        </div>
        <iframe src="FacultyUpcomingCourse.jsp" name="OurIframe" id="Courses"> </iframe>
    </div>

    <form action="UpdateFacultyPreferences.jsp" method="POST" id="UpdatePreferencesForm">
        <h4 id="WorkHead">Update your preferences</h4>

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

            String[] allsubjects = new String[i];
        %>

        <%-- Faculty's Preferences --%>
    <%
        String faculty_code = (String) application.getAttribute("session_faculty");
        int count_subjects = 0, count_platforms = 0, count_timing = 0;
        try 
        {
            Class.forName("com.mysql.jdbc.Driver");   //to load driver class
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                            //to build connection between Java and database 
            Statement stmt=con.createStatement();  //create statement class object
            stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                    //"if not exists" used because of database not created multiple times(error)
                
            stmt.execute("Use Modern_Gyan_Db");

            ResultSet rs = stmt.executeQuery("SELECT count(*) from "+ faculty_code +"_subjectcode_Tb");
            while(rs.next())
                count_subjects = rs.getInt(1);

            rs = stmt.executeQuery("SELECT count(*) from "+ faculty_code +"_platform_Tb");
            while(rs.next())
                count_platforms = rs.getInt(1);

            String slot = "";
            rs = stmt.executeQuery("SELECT slot1, slot2, slot3, slot4, slot5, slot6 from "+ faculty_code +"_timing_Tb");
            while(rs.next())
            {   
                for(i=1; i<=6 && rs.getString(i)!=null; i++)
                    count_timing++;
                break;
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

        i = 0;
        String[] subject_code = new String[count_subjects];
        String[] subject_name = new String[count_subjects];
        int[] platform_id = new int[count_platforms];
        String[] platform = new String[count_platforms];
        String[] slots = new String[count_timing];
        String[] slotfrom = new String[count_timing];
        String[] slotto = new String[count_timing];

        try 
        {
            Class.forName("com.mysql.jdbc.Driver");   //to load driver class
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                            //to build connection between Java and database 
            Statement stmt=con.createStatement();  //create statement class object
            stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                    //"if not exists" used because of database not created multiple times(error)
                
            stmt.execute("Use Modern_Gyan_Db");

            ResultSet rs = stmt.executeQuery("SELECT subject_code from "+ faculty_code +"_subjectcode_Tb");
            while(rs.next())
            {
                subject_code[i] = rs.getString(1);
                i++;
            }

            /* Preferred subjects */
            PreparedStatement pstmt = null;
            for(i=0; i<count_subjects; i++)
            {
                pstmt = con.prepareStatement("SELECT subject_name from SubjectTb where subject_code = ?");
                pstmt.setString(1, subject_code[i]);
                rs = pstmt.executeQuery();
                while(rs.next())
                    subject_name[i] = rs.getString(1);
            }

            /* Preferred platform */
            i=0;
            rs = stmt.executeQuery("SELECT platform from "+ faculty_code +"_platform_Tb order by platform_id");
            while(rs.next())
            {
                platform[i] = rs.getString(1);
                i++;
            }

            /* Preferred time slots */
            rs = stmt.executeQuery("SELECT slot1, slot2, slot3, slot4, slot5, slot6 from "+ faculty_code +"_timing_Tb");
            while(rs.next())
            {
                for(i=0; i<count_timing; i++)
                    slots[i] = rs.getString(i+1);
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

            // Separating time string in different times
            for(i=0; i<count_timing; i++)
            {
                slotfrom[i] = slots[i].substring(0, (slots[i].indexOf("-")-1));
                slotto[i] = slots[i].substring(slots[i].indexOf("-")+2);
            }
        %>

        <fieldset id="Subjects">
            <legend> Enter preferred subjects </legend>

            <table>
                <tr>
                    <th> <label for="sub_name1"> Subject 1 : </label>     
                    <td> <select name="cbSubName" id="sub_name1">
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
                                    allsubjects[i]=rs.getString("subject_name");
                                    out.print("<option value='"+allsubjects[i]+"'>"+allsubjects[i]+"</option>");
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
                    <td> <select name="cbSubName" id="sub_name2">
                        <option>Select subject</option>
                        <%
                            for(i=0; i<allsubjects.length; i++)
                                out.print("<option value='"+allsubjects[i]+"'>"+allsubjects[i]+"</option>");
                        %>
                    </select> </td>

                    <th> <label for="sub_name3"> Subject 3 : </label>
                    <td> <select name="cbSubName" id="sub_name3">
                        <option>Select subject</option>
                        <%
                            for(i=0; i<allsubjects.length; i++)
                                out.print("<option value='"+allsubjects[i]+"'>"+allsubjects[i]+"</option>");
                        %>
                    </select> </td>
                </tr>

                <tr>
                    <th> <label for="sub_name4"> Subject 4 : </label> </th>
                    <td> <select name="cbSubName" id="sub_name4">
                        <option>Select subject</option>
                        <%
                            for(i=0; i<allsubjects.length; i++)
                                out.print("<option value='"+allsubjects[i]+"'>"+allsubjects[i]+"</option>");
                        %>
                    </select> </td>

                    <th> <label for="sub_name5"> Subject 5 : </label> </th>
                    <td> <select name="cbSubName" id="sub_name5">
                        <option>Select subject</option>
                        <%
                            for(i=0; i<allsubjects.length; i++)
                                out.print("<option value='"+allsubjects[i]+"'>"+allsubjects[i]+"</option>");
                        %>
                    </select> </td>
                    
                    <th> <label for="sub_name6"> Subject 6 : </label> </th>
                    <td> <select name="cbSubName" id="sub_name6">
                        <option>Select subject</option>
                        <%
                            for(i=0; i<allsubjects.length; i++)
                                out.print("<option value='"+allsubjects[i]+"'>"+allsubjects[i]+"</option>");
                        %>
                    </select> </td>
                </tr>
            </table>     
        </fieldset>

        <%-- setting the subject names already preferred selected --%>
        <%
            for(i=0; i<count_subjects; i++)
            {
                %><script> document.getElementById("sub_name<%=i+1%>").value = "<%=subject_name[i]%>"; </script><%
            }
        %>

        <fieldset id="Slots">
            <legend> Enter preferred time slots </legend>

            <table>
                <tr>
                    <th> Slot 1 : </th>
                    <td> <input type="time" name="timeSlotfrom" id="slot1from" class="TimeSlots"> to
                        <input type="time" name="timeSlotto" id="slot1to" class="TimeSlots"> </td>
                    <th> Slot 2 : </th>
                    <td> <input type="time" name="timeSlotfrom" id="slot2from" class="TimeSlots"> to
                        <input type="time" name="timeSlotto" id="slot2to" class="TimeSlots"> </td>
                    <th> Slot 3 : </th>
                    <td> <input type="time" name="timeSlotfrom" id="slot3from" class="TimeSlots"> to    
                        <input type="time" name="timeSlotto" id="slot3to" class="TimeSlots"> </td>
                <tr>
                </tr>
                    <th> Slot 4 : </th>
                    <td> <input type="time" name="timeSlotfrom" id="slot4from" class="TimeSlots"> to
                        <input type="time" name="timeSlotto" id="slot4to" class="TimeSlots"> </td>
                    <th> Slot 5 : </th>
                    <td> <input type="time" name="timeSlotfrom" id="slot5from" class="TimeSlots"> to
                        <input type="time" name="timeSlotto" id="slot5to" class="TimeSlots"> </td>
                    <th> Slot 6 : </th>
                    <td> <input type="time" name="timeSlotfrom" id="slot6from" class="TimeSlots"> to
                        <input type="time" name="timeSlotto" id="slot6to" class="TimeSlots"> </td>
                </tr>
            </table>
        </fieldset>

        <%-- setting the timing slots already preferred selected --%>
        <%
            for(i=0; i<count_timing; i++)
            {
                %><script> 
                    document.getElementById("slot<%=i+1%>from").value = "<%=slotfrom[i]%>"; 
                    document.getElementById("slot<%=i+1%>to").value = "<%=slotto[i]%>"; 
                </script><%
            }
        %>

        <fieldset id="platforms">
            <legend> Choose from available platforms </legend>

            <table width="1000px" height="40px">
                <tr>
                    <td> <input type="checkbox" id="platform1" name="cbPlatforms" value="Google meet"
                    <%    
                        for(i=0; i<platform.length; i++)
                        {
                            if(platform[i].equals("Google meet"))
                            {
                                %> checked = "checked" <%
                                break;
                            }
                        }
                    %>
                    >
                    <label for="platform1"> Google meet </label> </td>
                    <td> <input type="checkbox" id="platform2" name="cbPlatforms" value="Zoom app"> <label for="platform2"
                    <%    
                        for(i=0; i<platform.length; i++)
                        {
                            if(platform[i].equals("Google meet"))
                            {
                                %> checked = "checked" <%
                                break;
                            }
                        }
                    %>> Zoom app </label> </td>
                    <td> <input type="checkbox" id="platform3" name="cbPlatforms" value="Cisco Webex"> <label for="platform3"> Cisco Webex </label> </td>
                    <td> <input type="checkbox" id="platform4" name="cbPlatforms" value="Jio meet"> <label for="platform4"> Jio meet </label> </td>
                </tr>
            </table>
        </fieldset>

        <%-- setting the platforms already preferred selected --%>
        <%-- <script>
            for(var j=0; j<4; j++)
            {
                for(var i=0; i< "<%= platform.length %>"; i++)
                {
                    if(document.getElementsByName("cbPlatforms").item(j).value == "<%=platform[i]%>")
                    {
                        document.getElementsByName("cbPlatforms").item(j).checked = true;
                        break;
                    }
                }
            }
        </script> --%>

        <div id="UpdateBtn"> <input type="submit" name="sbUpdate" value="Update"> </div>
    </form>
     
    <%-- Success Message --%>
    <div id="SuccessMessage"> <label id="lbMessage">  </label> </div>
    <%
        if((String) application.getAttribute("updatestatus") != null)
        {
            %><script> 
                window.scrollTo(0, document.getElementsByTagName("body").item(0).scrollHeight);
                document.getElementById('UpdatePreferencesForm').style.filter='blur(1px)';
                document.getElementById("lbMessage").style.visibility="visible"; 
                document.getElementById("lbMessage").style.boxShadow="1px 1px 6px gray"; 
                document.getElementById("lbMessage").innerHTML = "Preferences updated successfully <i class='fa-solid fa-check'></i>";
                window.setTimeout('document.getElementById("lbMessage").style.opacity="0"; document.getElementById("lbMessage").style.visibility="hidden";'
                    + ' document.getElementById("UpdatePreferencesForm").style.filter="blur(0px)"; document.getElementById("lbMessage").style.boxShadow="none";',4000);
            </script><%
        }

        else
        {
            %><script> 
                document.getElementById("lbMessage").style.visibility="hidden"; 
                document.getElementById("lbMessage").innerHTML = "";
            </script><%
        }

        application.removeAttribute("updatestatus");
    %>

</body>
</html>