<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Student Home | Modern-Gyan</title>
    <link rel="stylesheet" href="StudentHome.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

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

    <%-- Header Panel --%>
    <header>
        <span id="greeting">Hi ${applicationScope.session_student}</span>
        <span id="SiteName" title="Modern-Gyan"> Modern-Gyan </span>
        <a href="FindCourse.jsp"> <i class='fas fa-search' ></i> Search for courses </a>
        <form name="direct" id="LogBtn"> 
            <input type="submit" name="btLogin" value="login" onclick="direct.action='../LoginPage.jsp'">
            <input type="submit" name="btLogout" value="logout" onclick="direct.action='../LogoutPage.jsp'"> 
        </form>
    </header>

    <%-- Courses iframe panel --%>
    <div id="IframePanel">
        <div id="IframeSrcPanel"> 
            <a href="StudentUpcomingCourse.jsp" target="OurIframe" class="CoursesLink" onclick="LinkSelected(0)"> Upcoming </a>
            <a href="StudentOngoingCourse.jsp" target="OurIframe" class="CoursesLink" onclick="LinkSelected(1)"> In Progress </a>
            <a href="StudentCompletedCourse.jsp" target="OurIframe" class="CoursesLink" onclick="LinkSelected(2)"> Completed </a>
        </div>
        <iframe src="StudentUpcomingCourse.jsp" name="OurIframe" id="CoursesFrame"> </iframe>
    </div>
     
     <%-- Selecting student userid and branch name, setting course limit and not logged in preferences --%>
    <%
        int count = 5;
        String student_id = (String) application.getAttribute("session_student");
        String branch_name = "", branch_code = "";
        if(student_id != null)
        {
            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                            
                stmt.execute("Use Modern_Gyan_Db");

                PreparedStatement pstmt = con.prepareStatement("select branch_name from StudentTb where userid = ?");
                pstmt.setString(1, student_id);
                ResultSet rs = pstmt.executeQuery();
                while(rs.next())
                    branch_name = rs.getString(1);

                pstmt = con.prepareStatement("select branch_code from BranchTb where branch_name = ?");
                pstmt.setString(1, branch_name);
                rs = pstmt.executeQuery();
                while(rs.next())
                    branch_code = rs.getString(1);

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
            
            %><script> 
                document.getElementsByName("btLogin").item(0).style.display = "none";
            </script><%
        }

        else
        {
            %><script> 
                document.getElementsByName("btLogout").item(0).style.display = "none";

                document.getElementById("IframePanel").style.padding = "10px 0px";
                document.getElementById("IframePanel").innerHTML = "<label id='Message'> Login/Register to enroll courses and access your courses. </label>";
            </script><%
        }
    %>
     
    <%-- Famous Subjects list display --%>
    <span class="PanelName" title="Most preferred Subjects"> Most preferred subjects </span>
    <div id="CoursesSubjectDisplay">
        <form action="CourseEnroll.jsp" method="POST" id="SubjectsDisplayForm">
            <%  
                String course_type = "Subject";
                String[] subject_name = new String[count];
                String[] subject_code = new String[count];
                String[] subject_fees = new String[count];
                int[] student_enrolled = new int[count];

                out.print("<div id='CoursesHead'> <label class='SerialNo underline'> S. No. </label> <label class='CourseDataHead largesize'>"
                + " Subject Name </label> <label class='CourseDataHead smallsize'> Subject Code </label> <label class='CourseDataHead smallsize'> Subject Fee </label>"
                + " <label class='CourseDataHead smallsize'> Students Enrolled </label> <label class='CourseDataHead smallsize'> Subject Details </label> </div>");

                if(student_id == null)
                {
                    try 
                    {
                        Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                        Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                        //to build connection between Java and database 
                        Statement stmt=con.createStatement();  //create statement class object
                        stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                                //"if not exists" used because of database not created multiple times(error)
                                    
                        stmt.execute("Use Modern_Gyan_Db");

                        int i=0;
                        ResultSet rs = stmt.executeQuery("SELECT subject_name, subject_code, fees, student_enrolled from subjectTb ORDER BY"
                            + " student_enrolled desc LIMIT 5");
                        while(rs.next())
                        {
                            subject_name[i] = rs.getString(1);
                            subject_code[i] = rs.getString(2);
                            subject_fees[i] = rs.getString(3);
                            student_enrolled[i] = rs.getInt(4);

                            out.print("<div class='Courses'> <label class='SerialNo'>"+ (i+1) +".</label> <input type='text' name='txCourseName"+i+"' value='"
                                + subject_name[i] + "' class='largesize' readonly/> <input type='text' name='txCourseCode"+i+"' value='"+ subject_code[i] 
                                + "' class='smallsize' readonly/><input type='text' name='txCourseFees"+i+"' value='" + subject_fees[i] +"' class='smallsize'"
                                + " readonly/> <input type='text' name='txStudentEnrolled"+i+"' value='"+ student_enrolled[i] +"' class='smallsize' readonly/>"
                                + " <input type='hidden' name='txCategory"+i+"' value='"+ course_type +"'/> <div class='DetailsBtn smalsmall'>"
                                + " <input type='submit' name='sbCourseDetails"+i+"' value='Details'/> </div> </div>");
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
                }

                else
                {
                    try 
                    {
                        Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                        Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                        //to build connection between Java and database 
                        Statement stmt=con.createStatement();  //create statement class object
                        stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                                //"if not exists" used because of database not created multiple times(error)
                                    
                        stmt.execute("Use Modern_Gyan_Db");

                        PreparedStatement pstmt = con.prepareStatement("SELECT subject_name, subject_code, fees, student_enrolled from subjectTb where branch_code=?"
                            + " ORDER BY student_enrolled desc LIMIT 5");
                        pstmt.setString(1, branch_code);
                        ResultSet rs = pstmt.executeQuery();
                        int i=0;
                        while(rs.next())
                        {
                            subject_name[i] = rs.getString(1);
                            subject_code[i] = rs.getString(2);
                            subject_fees[i] = rs.getString(3);
                            student_enrolled[i] = rs.getInt(4);

                            out.print("<div class='Courses'> <label class='SerialNo'>"+ (i+1) +".</label> <input type='text' name='txCourseName"+i+"' value='"
                                + subject_name[i] + "' class='largesize' readonly/> <input type='text' name='txCourseCode"+i+"' value='"+ subject_code[i] 
                                + "' class='smallsize' readonly/><input type='text' name='txCourseFees"+i+"' value='" + subject_fees[i] +"' class='smallsize'"
                                + " readonly/> <input type='text' name='txStudentEnrolled"+i+"' value='"+ student_enrolled[i] +"' class='smallsize' readonly/>"
                                + " <input type='hidden' name='txCategory"+i+"' value='"+ course_type +"'/> <div class='DetailsBtn smalsmall'>"
                                + " <input type='submit' name='sbCourseDetails"+i+"' value='Details'/> </div> </div>");
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
                }
            %>
        </form>
    </div>

    <%-- Famous Topics list display --%>
    <span class="PanelName" title="Most preferred Topics"> Most preferred topics </span>
    <div id="CoursesTopicDisplay">
        <form action="CourseEnroll.jsp" method="POST" id="TopicsDisplayForm">
            <%  
                course_type = "Topic";
                String[] topic_name = new String[count];
                String[] topic_code = new String[count];
                String[] topic_fees = new String[count];

                out.print("<div id='CoursesHead'> <label class='SerialNo underline'> S. No. </label> <label class='CourseDataHead largesize'>"
                + " Topic Name </label> <label class='CourseDataHead smallsize'> Topic Code </label> <label class='CourseDataHead smallsize'> Topic Fee </label>"
                + " <label class='CourseDataHead smallsize'> Students Enrolled </label> <label class='CourseDataHead smallsize'> Topic Details </label> </div>");

                if(student_id == null)
                {
                    try 
                    {
                        Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                        Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                        //to build connection between Java and database 
                        Statement stmt=con.createStatement();  //create statement class object
                        stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                                //"if not exists" used because of database not created multiple times(error)
                                    
                        stmt.execute("Use Modern_Gyan_Db");

                        int i=0;
                        ResultSet rs = stmt.executeQuery("SELECT topic_name, topic_code, fees, student_enrolled from TopicTb ORDER BY"
                            + " student_enrolled desc LIMIT 5");
                        while(rs.next())
                        {
                            topic_name[i] = rs.getString(1);
                            topic_code[i] = rs.getString(2);
                            topic_fees[i] = rs.getString(3);
                            student_enrolled[i] = rs.getInt(4);

                            out.print("<div class='Courses'> <label class='SerialNo'>"+ (i+1) +".</label> <input type='text' name='txCourseName"+i+"' value='"
                                + topic_name[i] + "' class='largesize' readonly/> <input type='text' name='txCourseCode"+i+"' value='"+ topic_code[i] 
                                + "' class='smallsize' readonly/><input type='text' name='txCourseFees"+i+"' value='" + topic_fees[i] +"' class='smallsize'"
                                + " readonly/> <input type='text' name='txStudentEnrolled"+i+"' value='"+ student_enrolled[i] +"' class='smallsize' readonly/>"
                                + " <input type='hidden' name='txCategory"+i+"' value='"+ course_type +"'/> <div class='DetailsBtn smalsmall'>"
                                + " <input type='submit' name='sbCourseDetails"+i+"' value='Details'/> </div> </div>");
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
                }

                else
                {
                    try 
                    {
                        Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                        Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                        //to build connection between Java and database 
                        Statement stmt=con.createStatement();  //create statement class object
                        stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                                //"if not exists" used because of database not created multiple times(error)
                                    
                        stmt.execute("Use Modern_Gyan_Db");

                        int sub_count = 0;
                        PreparedStatement pstmt = con.prepareStatement("SELECT count(*) from SubjectTb where branch_code = ?");
                        pstmt.setString(1, branch_code);
                        ResultSet rs = pstmt.executeQuery();
                        while(rs.next())
                            sub_count = rs.getInt(1);

                        int i=0;
                        String[] sub_code = new String[sub_count];
                        pstmt = con.prepareStatement("SELECT subject_code from SubjectTb where branch_code = ?");
                        pstmt.setString(1, branch_code);
                        rs = pstmt.executeQuery();
                        while(rs.next())
                        {
                            sub_code[i] = rs.getString(1);
                            i++;
                        }

                        String condition = "";
                        for(i=0; i<sub_count; i++)
                        {
                            if(i<sub_count-1)
                                condition += " subject_code=? or";
                            else
                                condition += " subject_code=?";
                        }

                        pstmt = con.prepareStatement("SELECT topic_name, topic_code, fees, student_enrolled from TopicTb where "+ condition
                            + " ORDER BY student_enrolled desc LIMIT 5");
                        for(i=0; i<sub_count; i++)
                            pstmt.setString(i+1, sub_code[i]);
                        rs = pstmt.executeQuery();
                        i=0;
                        while(rs.next())
                        {
                            topic_name[i] = rs.getString(1);
                            topic_code[i] = rs.getString(2);
                            topic_fees[i] = rs.getString(3);
                            student_enrolled[i] = rs.getInt(4);

                            out.print("<div class='Courses'> <label class='SerialNo'>"+ (i+1) +".</label> <input type='text' name='txCourseName"+i+"' value='"
                                + topic_name[i] + "' class='largesize' readonly/> <input type='text' name='txCourseCode"+i+"' value='"+ topic_code[i] 
                                + "' class='smallsize' readonly/> <input type='text' name='txCourseFees"+i+"' value='" + topic_fees[i] +"' class='smallsize'"
                                + " readonly/> <input type='text' name='txStudentEnrolled"+i+"' value='"+ student_enrolled[i] +"' class='smallsize' readonly/>"
                                + " <input type='hidden' name='txCategory"+i+"' value='"+ course_type +"'/> <div class='DetailsBtn smalsmall'>"
                                + " <input type='submit' name='sbCourseDetails"+i+"' value='Details'/> </div> </div>");
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
                }
            %>
        </form>
    </div>

</body>
</html>