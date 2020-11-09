<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Faculty Ongoing Courses | Modern-Gyan</title>
    <link rel="stylesheet" href="FacultyOngoingCourse.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

</head>

<body>

    <%
        int c=0;
        String faculty_code = (String) application.getAttribute("session_faculty");

        // today's date
        long millis = System.currentTimeMillis();
        Date today_date = new Date(millis);

        // Counting in progress courses
        try 
        {
            Class.forName("com.mysql.jdbc.Driver");   //to load driver class
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                            //to build connection between Java and database 
            Statement stmt=con.createStatement();  //create statement class object
            stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                    //"if not exists" used because of database not created multiple times(error)
                
            stmt.execute("Use Modern_Gyan_Db");

            PreparedStatement pstmt = con.prepareStatement("SELECT count(*) from "+ faculty_code +"_assignsubject_Tb where assign_date <= ? and finish_date >= ?");
            pstmt.setDate(1, today_date);
            pstmt.setDate(2, today_date);

            ResultSet rs = pstmt.executeQuery();
            while(rs.next())
                c = rs.getInt(1);

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

        int i=0;

        int[] platform_id = new int[c];
        int[] slotno = new int[c];
        String[] subject_code = new String[c];

        String[] platform = new String[c];
        String[] timeslot = new String[c];
        String[] subject_name = new String[c];
        String[] meeting_id = new String[c];
        String[] meeting_password = new String[c];
        int[] student_enrolled = new int[c];
        Date[] assign_date = new Date[c];
        Date[] finish_date = new Date[c];

        if(c == 0)
            out.print("<div id='EmptyMessage'><label> All your course classes which are in progress will appear here. </label></div>");
        else
        {
            // getting the courses information
            try
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                    
                stmt.execute("Use Modern_Gyan_Db");

                PreparedStatement pstmt = con.prepareStatement("SELECT platform_id, slotno, subject_code, meeting_id, meeting_password, student_enrolled, assign_date,"
                    + " finish_date from " + faculty_code +"_assignsubject_Tb where assign_date <= ? and finish_date >= ?");
                pstmt.setDate(1, today_date);
                pstmt.setDate(2, today_date);

                ResultSet rs = pstmt.executeQuery();
                while(rs.next())
                {
                    platform_id[i] = rs.getInt(1);
                    slotno[i] = rs.getInt(2);
                    subject_code[i] = rs.getString(3);
                    meeting_id[i] = rs.getString(4);
                    meeting_password[i] = rs.getString(5);
                    student_enrolled[i] = rs.getInt(6);
                    assign_date[i] = rs.getDate(7);
                    finish_date[i] = rs.getDate(8);
                    i++;
                }

                // Obtaining platform, time slot and subject code 
                for(i=0; i<c; i++)
                {
                    pstmt = con.prepareStatement("SELECT platform from "+ faculty_code +"_platform_Tb where platform_id=?");
                    pstmt.setInt(1, platform_id[i]);
                    rs = pstmt.executeQuery();
                    while(rs.next())
                        platform[i] = rs.getString(1);

                    rs = stmt.executeQuery("SELECT slot"+ slotno[i] +" from "+ faculty_code +"_timing_Tb");
                    while(rs.next())
                        timeslot[i] = rs.getString(1);

                    int count=0;
                    pstmt = con.prepareStatement("SELECT count(*) from SubjectTb where subject_code=?");
                    pstmt.setString(1, subject_code[i]);
                    rs = pstmt.executeQuery();
                    while(rs.next())
                        count = rs.getInt(1);

                    if(count == 0)
                    {
                        pstmt = con.prepareStatement("SELECT topic_name from TopicTb where topic_code=?");
                        pstmt.setString(1, subject_code[i]);
                        rs = pstmt.executeQuery();
                        while(rs.next())
                            subject_name[i] = rs.getString(1);
                    }
                    else 
                    {
                        pstmt = con.prepareStatement("SELECT subject_name from SubjectTb where subject_code=?");
                        pstmt.setString(1, subject_code[i]);
                        rs = pstmt.executeQuery();
                        while(rs.next())
                            subject_name[i] = rs.getString(1);
                    }
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
        }
    %>

    <%-- Displaying course data --%>
    <%
        for(i=0; i<c; i++)
        {
            %>
            <div class="OngoingCourses">
                <form action="UpdateMeetingDetails.jsp" method="POST">
                    <span> 
                        <input type="text" name="txSubjectName<%=i%>" class="SubjectName Largesize Readonly" value="<%= subject_name[i] %>" readonly/>
                        <input type="hidden" name="hdSubCode<%=i%>" value="<%= subject_code[i] %>" readonly/>
                    </span>
                    <div class="Details1">
                        <div>
                            <label for="StudentEnrolled<%=i%>" class="lbcontent"> Students </label><label class=" colon">:</label>
                            <input type="text" name="txStudentEnrolled<%=i%>" id="StudentEnrolled<%=i%>" class="StudentEnrolled Smallsize Readonly" value="<%= student_enrolled[i] %>" readonly/>
                        </div>
                        <div>
                            <label for="TimeSlots<%=i%>" class="lbcontent"> Time slot </label><label class=" colon">:</label>
                            <input type="text" name="txTimeSlot<%=i%>" id="TimeSlots<%=i%>" class="TimeSlot Smallsize Readonly" value="<%= timeslot[i] %>" readonly/>
                            <input type="hidden" name="hdSlotNo<%=i%>" value="<%= slotno[i] %>" readonly/>
                        </div>
                        <div>
                            <label for="AssignDate<%=i%>" class="lbcontent"> Assign Date </label><label class="colon">:</label>
                            <input type="date" name="txAssignDate<%=i%>" id="AssignDate<%=i%>" class="AssignDate Smallsize Readonly" value="<%= assign_date[i] %>" readonly/>
                        </div>
                        <div>
                            <label for="FinishDate<%=i%>" class="lbcontent"> Finish Date </label><label class="colon">:</label>
                            <input type="date" name="txFinishDate<%=i%>" id="FinishDate<%=i%>" class="FinishDate Smallsize Readonly" value="<%= finish_date[i] %>" readonly/>
                        </div>
                    </div>
                    <div class="Details2">
                        <div>
                            <label for="Platform<%=i%>" class="lbcontent"> Platform : </label>
                            <input type="text" name="txPlatform<%=i%>" id="Platform<%=i%>" class="Platform Smallsize Readonly" value="<%= platform[i] %>" readonly/>
                        </div>
                        <div>
                            <label name="lbMeetingId<%=i%>" class="lbcontent"> Meeting Id : </label> 
                            <input type="text" name="txMeetId<%=i%>" class="MeetingId alert Smallsize" value="<%= meeting_id[i] %>"/>
                        </div>
                        <div>
                            <label name="lbMeetingPassword<%=i%>" class="lbcontent"> Meeting Password : </label> 
                            <input type="text" name="txMeetPass<%=i%>" class="MeetingPassword alert Smallsize" value="<%= meeting_password[i] %>"/>
                        </div>
                        <button type="submit" name="sbSend<%=i%>" id="sbSend<%=i%>" class="SendBtn" title="Send"> <i class="fa fa-paper-plane-o"></i> </button>
                    </div>
                </form>
            </div>
            <%
        }
    %>

    <%
        for(i=0; i<c; i++)
        {
            if(meeting_id[i] == null || meeting_password == null)
            {
                %><script>
                    document.getElementsByName("txMeetId<%=i%>").item(0).value = "";
                    document.getElementsByName("txMeetId<%=i%>").item(0).style.border = "1px solid red";
                    document.getElementsByName("txMeetId<%=i%>").item(0).style.borderRadius = "4px";
                    document.getElementsByName("txMeetId<%=i%>").item(0).style.animation = "Blink 1s ease-in-out 0.4s infinite both";
                    document.styleSheets[0].addRule(".MeetingId:focus", "animation: none !important;", 0);
                
                    document.getElementsByName("txMeetPass<%=i%>").item(0).value = "";
                    document.getElementsByName("txMeetPass<%=i%>").item(0).style.border = "1px solid red";
                    document.getElementsByName("txMeetPass<%=i%>").item(0).style.borderRadius = "4px";
                    document.getElementsByName("txMeetPass<%=i%>").item(0).style.animation = "Blink 1s ease-in-out 0.4s infinite both";
                    document.styleSheets[0].addRule(".MeetingPass:focus", "animation: none !important", 0);
                </script><%
            }
            else
            {
                %><script>
                    document.getElementById("sbSend<%=i%>").style.display = "none";

                    document.getElementsByName("txMeetId<%=i%>").item(0).readOnly = true;
                    document.getElementsByName("txMeetId<%=i%>").item(0).style.border = "none";
                    document.styleSheets[0].addRule(".MeetingId:focus", "outline: none", 0);
                
                    document.getElementsByName("txMeetPass<%=i%>").item(0).readOnly = true;
                    document.getElementsByName("txMeetPass<%=i%>").item(0).style.border = "none";
                    document.styleSheets[0].addRule(".MeetingPassword:focus", "outline: none", 0);
                </script><%
            }
        }
    %>
 
    <%-- Success Message --%>
    <div id="SuccessMessage"> <label id="lbMessage">  </label> </div>
    <%
        if((String) application.getAttribute("status") != null)
        {
            %><script> 
                document.getElementsByClassName('OngoingCourses').item(0).style.filter='blur(1px)';
                document.getElementById("lbMessage").style.visibility="visible"; 
                document.getElementById("lbMessage").style.boxShadow="1px 1px 6px gray"; 
                document.getElementById("lbMessage").innerHTML = "Done <i class='fa fa-thumbs-up'></i>";
                window.setTimeout('document.getElementById("lbMessage").style.opacity="0"; document.getElementById("lbMessage").style.visibility="hidden";'
                    + ' document.getElementsByClassName("OngoingCourses").item(0).style.filter="blur(0px)"; document.getElementById("lbMessage").style.boxShadow="none";',4000);
            </script><%
        }

        else
        {
            %><script> 
                document.getElementById("lbMessage").style.visibility="hidden"; 
                document.getElementById("lbMessage").innerHTML = "";
            </script><%
        }

        application.removeAttribute("status");
    %>

</body>
</html>