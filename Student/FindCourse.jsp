<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title> Find course | Modern-Gyan </title>
    <link rel="stylesheet" href="FindCourse.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>
    
</head>

<body>

    <%-- Header Panel --%>
    <header>
        <form action="StudentHome.jsp" id="HomeBtn"> <button type="submit" name="btHome"> <i class='fas fa-house-user'></i> </button> </form>
        <span id="greeting">Hi ${applicationScope.session_student}</span>
        <span id="SiteName" title="Modern-Gyan"> Modern-Gyan </span>
        <form action="FindCourse.jsp" id=SearchBarForm>
            <div id="SearchBar">
                <input type="search" name="txSearch" id="Search" placeholder="Search"><button type="submit" name="sbSearch"> <i class='fas fa-search' ></i> </button>
            </div>
        </form>
        <form action="../LogoutPage.jsp" id="LogoutBtn"> <input type="submit" name="btLogout" value="logout"> </form>
    </header>

    <%-- Course Filter panel --%>
    <fieldset id="Filter">
        <legend> Filter search </legend>
        <form action="FindCourse.jsp" method="POST">
            <select name="cbBranchname" id="BranchName">
                <option value="-1">Select Branch name</option>
                <%
                    try 
                    {
                        Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                        Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                        //to build connection between Java and database 
                        Statement stmt=con.createStatement();  //create statement class object
                        stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                                //"if not exists" used because of database not created multiple times(error)
                                    
                        stmt.execute("Use Modern_Gyan_Db");

                        ResultSet rs=stmt.executeQuery("select branch_name from BranchTb");
                        String branch_name="";
                        while(rs.next())
                        {
                            branch_name=rs.getString("branch_name");
                            out.print("<option value='"+branch_name+"'>"+branch_name+"</option>");
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
            </select>
            
            <span id="CourseType">
                <label id=lbCourseType> Select course type : </label>
                <input type="radio" name="rbCourseType" id="subject" value="Subject">
                <label for="subject">Subject</label>
                <input type="radio" name="rbCourseType" id="topic" value="Topic">
                <label for="topic">Topic</label>
            </span>

            <input type="submit" id="sbcourseshow" name="sbCourseShow" value="Show">
        </form>
    </fieldset>

    <%-- Courses list display --%>
    <div id="CoursesDisplay">
        <form action="CourseEnroll.jsp" method="POST" id="CoursesDisplayForm">
            <%  
                out.print("<div id='CoursesHead'> <label class='SerialNo underline'> S. No. </label> <label class='CourseDataHead largesize'>"
                + " Course Name </label> <label class='CourseDataHead smallsize'> Course Code </label> <label class='CourseDataHead smallsize'> Course Fee </label>"
                + " <label class='CourseDataHead smallsize'> Course Category </label> <label class='CourseDataHead smallsize'> Course Details </label> </div>");

                if(request.getParameter("sbCourseShow")!=null)
                {
					String coursetype = request.getParameter("rbCourseType");
                    String branch_name = request.getParameter("cbBranchname");
                    %>
                    <script>
                        document.getElementById("BranchName").value = "<%= branch_name %>";
                        for(var i=0; i<document.getElementsByName("rbCourseType").length; i++)
                        {
                            if(document.getElementsByName("rbCourseType").item(i).value == "<%= coursetype %>")
                            {
                                document.getElementsByName("rbCourseType").item(i).checked = "checked";
                                break;
                            }
                        }
                    </script>
                    <%

                    /* when only branch is selected */
                    int j=0;
                    if(coursetype == null)
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

                            PreparedStatement pstmt = con.prepareStatement("select branch_code from BranchTb where branch_name = ?");
                            pstmt.setString(1, branch_name);
                            String branch_code = "";
                            ResultSet rs = pstmt.executeQuery();
                            while(rs.next())
                                branch_code = rs.getString(1);

                            pstmt = con.prepareStatement("select subject_name, subject_code, fees from SubjectTb where branch_code = ?");
                            pstmt.setString(1, branch_code);

                            String subject_name="";
                            String subject_code="";
                            String subject_fees="";
                            rs = pstmt.executeQuery();
                            
                            while(rs.next())
                            {
                                subject_name=rs.getString(1);
                                subject_code=rs.getString(2);
                                subject_fees=rs.getString(3);
                                out.print("<div class='Courses'> <label class='SerialNo'>"+ (j+1) +".</label> <input type='text' name='txCourseName"+j+"'"
                                    + " value='" + subject_name + "' class='largesize' readonly/> <input type='text' name= 'txCourseCode"+j+"'"
                                    + " value='"+ subject_code + "' class='smallsize' readonly/><input type='text' name='txCourseFees"+j+"' value='"+ subject_fees + "'"
                                    + " class='smallsize' readonly/> <input type= 'text' name='txCategory"+j+"' value='Subject' class='smallsize' readonly/>"
                                    + " <div class='DetailsBtn smallsize'> <input type='submit' name='sbCourseDetails"+j+"' value='Details'/> </div> </div>");
                                j++;
                            }

                            int c = 0;
                            pstmt = con.prepareStatement("SELECT COUNT(*) from SubjectTb where branch_code = ?");
                            pstmt.setString(1, branch_code);
                            rs = pstmt.executeQuery();
                            while(rs.next())
                                c = rs.getInt(1);

                            String[] subject_codeT = new String[c];
                            int[] topic_count = new int[c];
                            c=0;
                            pstmt = con.prepareStatement("SELECT subject_code from SubjectTb where branch_code = ?");
                            pstmt.setString(1, branch_code);
                            rs = pstmt.executeQuery();
                            while(rs.next())
                            {
                                subject_codeT[c] = rs.getString(1);
                                c++;
                            }    
                            
                            for(int i=0; i<subject_codeT.length; i++)
                            {
                                pstmt = con.prepareStatement("SELECT COUNT(*) from TopicTb where subject_code = ?");
                                pstmt.setString(1, subject_codeT[i]);
                                rs = pstmt.executeQuery();
                                while(rs.next())
                                {
                                    topic_count[i] = rs.getInt(1);
                                }
                            }

                            String[][] topic_name = new String[c][];
                            String[][] topic_code = new String[c][];
                            String[][] topic_fees = new String[c][];
                            for(int i=0; i<topic_name.length; i++)
                            {
                                topic_name[i] = new String[topic_count[i]];
                                topic_code[i] = new String[topic_count[i]];
                                topic_fees[i] = new String[topic_count[i]];
                            }

                            for(int i=0; i<subject_codeT.length; i++)
                            {
                                c=0;
                                pstmt = con.prepareStatement("SELECT topic_name, topic_code, fees from TopicTb where subject_code = ?");
                                pstmt.setString(1, subject_codeT[i]);
                                rs = pstmt.executeQuery();
                                while(rs.next() && c<topic_count[i])
                                {
                                    topic_name[i][c] = rs.getString(1);
                                    topic_code[i][c] = rs.getString(2);
                                    topic_fees[i][c] = rs.getString(3);
                                    out.print("<div class='Courses'> <label class='SerialNo'>"+ (j+1) +".</label> <input type='text' name='txCourseName"+j+"' value='"
                                        + topic_name[i][c] + "' class='largesize' readonly/> <input type='text' name='txCourseCode"+j+"' value='"+ topic_code[i][c] 
                                        + "' class='smallsize' readonly/><input type='text' name='txCourseFees"+j+"' value='" + topic_fees[i][c] +"' class='smallsize'"
                                        + " readonly/> <input type='text' name='txCategory"+j+"' value='Topic' class='smallsize' readonly/> <div class='DetailsBtn smalsmall'>"
                                        + " <input type='submit' name='sbCourseDetails"+j+"' value='Details'/> </div> </div>");
                                    c++;
                                    j++;
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

                    /* when branch and course type subject is selected */
                    else if(coursetype.equals("Subject"))
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

                            PreparedStatement pstmt = con.prepareStatement("select branch_code from BranchTb where branch_name = ?");
                            pstmt.setString(1, branch_name);
                            String branch_code = "";
                            ResultSet rs = pstmt.executeQuery();
                            while(rs.next())
                                branch_code = rs.getString(1);

                            pstmt = con.prepareStatement("select subject_name, subject_code, fees from SubjectTb where branch_code = ?");
                            pstmt.setString(1, branch_code);

                            j=0;
                            String subject_name="";
                            String subject_code="";
                            String subject_fees="";
                            rs = pstmt.executeQuery();
                            while(rs.next())
                            {
                                subject_name=rs.getString(1);
                                subject_code=rs.getString(2);
                                subject_fees=rs.getString(3);
                                out.print("<div class='Courses'> <label class='SerialNo'>"+ (j+1) +".</label> <input type='text' name='txCourseName"+j+"'"
                                    + " value='" + subject_name + "' class='largesize' readonly/> <input type='text' name= 'txCourseCode"+j+"'"
                                    + " value='"+ subject_code + "' class='smallsize' readonly/><input type='text' name='txCourseFees"+j+"' value='"+ subject_fees + "'"
                                    + " class='smallsize' readonly/> <input type= 'text' name='txCategory"+j+"' value='Subject' class='smallsize' readonly/>"
                                    + " <div class='DetailsBtn smallsize'> <input type='submit' name='sbCourseDetails"+j+"' value='Details'/> </div> </div>");
                                j++;
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

                    /* when branch and course type topic is selected */
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

                            String branch_code = "";
                            PreparedStatement pstmt = con.prepareStatement("select branch_code from BranchTb where branch_name = ?");
                            pstmt.setString(1, branch_name);
                            ResultSet rs = pstmt.executeQuery();
                            while(rs.next())
                                branch_code = rs.getString(1);

                            int c = 0;
                            pstmt = con.prepareStatement("SELECT COUNT(*) from SubjectTb where branch_code = ?");
                            pstmt.setString(1, branch_code);
                            rs = pstmt.executeQuery();
                            while(rs.next())
                                c = rs.getInt(1);

                            String[] subject_code = new String[c];
                            int[] topic_count = new int[c];
                            c=0;
                            pstmt = con.prepareStatement("SELECT subject_code from SubjectTb where branch_code = ?");
                            pstmt.setString(1, branch_code);
                            rs = pstmt.executeQuery();
                            while(rs.next())
                            {
                                subject_code[c] = rs.getString(1);
                                c++;
                            }    
                            
                            for(int i=0; i<subject_code.length; i++)
                            {
                                pstmt = con.prepareStatement("SELECT COUNT(*) from TopicTb where subject_code = ?");
                                pstmt.setString(1, subject_code[i]);
                                rs = pstmt.executeQuery();
                                while(rs.next())
                                {
                                    topic_count[i] = rs.getInt(1);
                                }
                            }

                            String[][] topic_name = new String[c][];
                            String[][] topic_code = new String[c][];
                            String[][] topic_fees = new String[c][];
                            for(int i=0; i<topic_name.length; i++)
                            {
                                topic_name[i] = new String[topic_count[i]];
                                topic_code[i] = new String[topic_count[i]];
                                topic_fees[i] = new String[topic_count[i]];
                            }

                            for(int i=0; i<subject_code.length; i++)
                            {
                                c=0;j=0;
                                pstmt = con.prepareStatement("SELECT topic_name, topic_code, fees from TopicTb where subject_code = ?");
                                pstmt.setString(1, subject_code[i]);
                                rs = pstmt.executeQuery();
                                while(rs.next() && c<topic_count[i])
                                {
                                    topic_name[i][c] = rs.getString(1);
                                    topic_code[i][c] = rs.getString(2);
                                    topic_fees[i][c] = rs.getString(3);
                                    out.print("<div class='Courses'> <label class='SerialNo'>"+ (j+1) +".</label> <input type='text' name='txCourseName"+j+"' value='"
                                        + topic_name[i][c] + "' class='largesize' readonly/> <input type='text' name='txCourseCode"+j+"' value='"+ topic_code[i][c] 
                                        + "' class='smallsize' readonly/><input type='text' name='txCourseFees"+j+"' value='" + topic_fees[i][c] +"' class='smallsize'"
                                        + " readonly/> <input type='text' name='txCategory"+j+"' value='Topic' class='smallsize' readonly/> <div class='DetailsBtn smalsmall'>"
                                        + " <input type='submit' name='sbCourseDetails"+j+"' value='Details'/> </div> </div>");
                                    c++;
                                    j++;
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
                }

                /* SearchBar result */
                else if(request.getParameter("sbSearch")!=null)
                {
                    int j=0;
                    String search = request.getParameter("txSearch");
                    %>
                    <script>
                        document.getElementById("Search").value = "<%= search %>";
                    </script>
                    <%
                    if(search != "")
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

                            int subject_count=0, topic_count=0;
                            PreparedStatement pstmt = con.prepareStatement("SELECT COUNT(*) from SubjectTb where subject_name like ? or subject_code like ?");
                            pstmt.setString(1, "%"+search+"%");
                            pstmt.setString(2, "%"+search+"%");
                            ResultSet rs = pstmt.executeQuery();
                            while(rs.next())
                                subject_count=rs.getInt(1);

                            pstmt = con.prepareStatement("SELECT COUNT(*) from TopicTb where topic_name like ? or topic_code like ?");
                            pstmt.setString(1, "%"+search+"%");
                            pstmt.setString(2, "%"+search+"%");
                            rs = pstmt.executeQuery();
                            while(rs.next())
                                topic_count=rs.getInt(1);

                            if(subject_count > 0)
                            {
                                pstmt = con.prepareStatement("SELECT subject_name, subject_code, fees from SubjectTb where subject_name like ? or subject_code like ?");
                                pstmt.setString(1, "%"+search+"%");
                                pstmt.setString(2, "%"+search+"%");

                                j=0;
                                String subject_name="";
                                String subject_code="";
                                String subject_fees="";
                                rs = pstmt.executeQuery();
                                while(rs.next())
                                {
                                    subject_name=rs.getString(1);
                                    subject_code=rs.getString(2);
                                    subject_fees=rs.getString(3);
                                    out.print("<div class='Courses'> <label class='SerialNo'>"+ (j+1) +".</label> <input type='text' name='txCourseName"+j+"'"
                                    + " value='" + subject_name + "' class='largesize' readonly/> <input type='text' name= 'txCourseCode"+j+"'"
                                    + " value='"+ subject_code + "' class='smallsize' readonly/><input type='text' name='txCourseFees"+j+"' value='"+ subject_fees + "'"
                                    + " class='smallsize' readonly/> <input type= 'text' name='txCategory"+j+"' value='Subject' class='smallsize' readonly/>"
                                    + " <div class='DetailsBtn smallsize'> <input type='submit' name='sbCourseDetails"+j+"' value='Details'/> </div> </div>");
                                    j++;
                                }
                            }

                            else if(topic_count > 0)
                            {
                                pstmt = con.prepareStatement("SELECT topic_name, topic_code, fees from TopicTb where topic_name like ? or topic_code like ?");
                                pstmt.setString(1, "%"+search+"%");
                                pstmt.setString(2, "%"+search+"%");

                                j=0;
                                String topic_name="";
                                String topic_code="";
                                String topic_fees="";
                                rs = pstmt.executeQuery();
                                while(rs.next())
                                {
                                    topic_name = rs.getString(1);
                                    topic_code = rs.getString(2);
                                    topic_fees = rs.getString(3);
                                    out.print("<div class='Courses'> <label class='SerialNo'>"+ (j+1) +".</label> <input type='text' name='txCourseName"+j+"' value='"
                                        + topic_name + "' class='largesize' readonly/> <input type='text' name='txCourseCode"+j+"' value='"+ topic_code 
                                        + "' class='smallsize' readonly/><input type='text' name='txCourseFees"+j+"' value='" + topic_fees +"' class='smallsize'"
                                        + " readonly/> <input type='text' name='txCategory"+j+"' value='Topic' class='smallsize' readonly/> <div class='DetailsBtn smalsmall'>"
                                        + " <input type='submit' name='sbCourseDetails"+j+"' value='Details'/> </div> </div>");
                                    j++;
                                }
                            }

                            else
                            {
                                out.print("No related courses available, please refine your search!!");
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
                        out.print("Please enter something to search for..");
                    }
                }
            %>
        </form>
    </div>

    <%-- Success Message --%>
    <div id="SuccessMessage"> <label id="lbMessage">  </label> </div>
    <%
        if((String) application.getAttribute("status") != null)
        {
            %><script> 
                document.getElementById("CoursesDisplay").style.filter="blur(1px)"; 
                document.getElementById("lbMessage").style.visibility="visible"; 
                document.getElementById("lbMessage").style.boxShadow="1px 1px 6px gray"; 
                document.getElementById("lbMessage").innerHTML = "'Thank you.' Your enrollment request has been submitted. <i class='fa fa-thumbs-up'></i>";
                window.setTimeout('document.getElementById("lbMessage").style.opacity="0"; document.getElementById("lbMessage").style.visibility="hidden";'
                    + ' document.getElementById("CoursesDisplay").style.filter="blur(0px)"; document.getElementById("lbMessage").style.boxShadow="none";',4000);
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