<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title> Admin Home | Modern-Gyan </title>

    <link rel="stylesheet" href="AdminHome.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

    <script>
        function HideSubData() 
        {
            for(var i=0; i<document.getElementsByClassName("HiddenDetails").length; i++)
                document.getElementsByClassName("HiddenDetails").item(i).style.display="none";

            if(sessionStorage.getItem("facultydisplay_bar") == "expand")
                ExpandBar();
        }

        function DisplaySubData(classname, container) 
        {
            if(document.getElementsByClassName(classname).item(i).style.display=="none")
            {
                // document.getElementById(container).style.animation="ExpandDetails 0.3s ease-out 0s 1 forward";
                document.getElementById(container).style.border = "2px solid darkblue";
                document.getElementById(container).style.padding = "1% 20%";
                for(var i=0; i<document.getElementsByClassName(classname).length; i++)
                {
                    document.getElementsByClassName(classname).item(i).style.display="block";
                    document.getElementsByClassName(classname).item(i).style.visibility="visible";
                }
            }
            else
            {
                // document.getElementById(container).style.animation="ExpandDetails 0.3s ease-out 0s 1 reverse";
                document.getElementById(container).style.border = "2px solid ghostwhite";
                document.getElementById(container).style.padding = "0%";
                for(var i=0; i<document.getElementsByClassName(classname).length; i++)
                {
                    document.getElementsByClassName(classname).item(i).style.display="none";
                    document.getElementsByClassName(classname).item(i).style.visibility="hidden";
                }
            }
        }

        function ExpandBar()
        {
            document.getElementById("CurrentDetails").style.display = "none";
            // document.getElementById("student_count").style.display = "none";
            // document.getElementById("BtnPanel").style.display = "none";
            // document.getElementById("active_student_count").style.display = "none";
            // document.getElementById("faculty_count").style.display = "none";
            document.getElementById("FacultyDisplay").style.height = "84vh";
            document.getElementById("expandIcon").innerHTML = "<i class='fas fa-compress' onclick='ShrinkBar()'></i>";

            sessionStorage.setItem("facultydisplay_bar", "expand");
        }

        function ShrinkBar()
        {
            document.getElementById("CurrentDetails").style.display = "flex";
            // document.getElementById("student_count").style.display = "block";
            // document.getElementById("active_student_count").style.display = "block";
            // document.getElementById("faculty_count").style.display = "block";
            // document.getElementById("BtnPanel").style.display = "block";
            document.getElementById("FacultyDisplay").style.height = "58vh";
            document.getElementById("expandIcon").innerHTML = "<i class='fas fa-expand' onclick='ExpandBar()'></i>";

            sessionStorage.setItem("facultydisplay_bar", "shrink");
        }
    </script>
</head>
<body onload="HideSubData()">

    <%
        if((String) application.getAttribute("session_admin") == null)
        {
            %><script> 
                alert("You just logged out, Login to continue.."); 
                location.assign("AdminLogin.html");
            </script><%
        }
    %>

    <%-- Header Panel --%>
    <header>
        <span id="greeting">Welcome ${applicationScope.session_admin}</span>
        <span id="SiteName" title="Modern-Gyan"> Modern-Gyan </span>
        <form action="AdminHome.jsp" id="SearchBar">
            <div>
                <input type="search" name="txSearch" id="" placeholder="Search for faculty"><button type="submit"> <i class='fas fa-search' ></i> </button>
            </div>
        </form>
        <form action="../LogoutPage.jsp" id="LogoutBtn"><input type="submit" name="btLogout" value="logout"></form>
    </header>
    
    <div id="CurrentDetails">
        <%-- Branch wise student count display --%>
        <%
            int c=0;

            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                    
                stmt.execute("Use Modern_Gyan_Db");

                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) from BranchTb");
                while(rs.next())
                    c=rs.getInt(1);

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

        <%
            int i=0, total_students=0;
            int[] branch_students = new int[c];
            String[] branch_name = new String[c];

            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                    
                stmt.execute("Use Modern_Gyan_Db");

                ResultSet rs = stmt.executeQuery("SELECT branch_name from BranchTb");
                while(rs.next())
                {
                    branch_name[i] = rs.getString("branch_name");
                    i++;
                }

                PreparedStatement pstmt = null;
                for(i=0; i<branch_name.length; i++)
                {
                    pstmt=con.prepareStatement("SELECT COUNT(*) from StudentTb where branch_name = ?");
                    pstmt.setString(1, branch_name[i]);
                    rs = pstmt.executeQuery();

                    while(rs.next())
                        branch_students[i] = rs.getInt(1);
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

            for(i=0; i<branch_students.length; i++)
                total_students += branch_students[i];
        %>

        <div id ="student_count">   
            <h3 id="total_students" onclick="DisplaySubData('Registered_Students', 'student_count')"> Total number of Registered students : <%= total_students %> </h3>
            <%
                for(i=0; i<branch_name.length; i++)
                {
                    %> <p class="Registered_Students HiddenDetails"> <%= branch_name[i] + " : " + branch_students[i] %> </p> <%
                }
            %>
        </div>

        <%-- Active students count display --%>
        <%
            c=0;
            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                    
                stmt.execute("Use Modern_Gyan_Db");

                ResultSet rs = stmt.executeQuery("SELECT distinct branch_code from SubjectTb");
                while(rs.next())
                    c+=1;

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
        <%
            branch_name = new String[c];
            String[] branch_code = new String[c];
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

                ResultSet rs = stmt.executeQuery("SELECT distinct branch_code from SubjectTb");
                while(rs.next())
                {
                    branch_code[i] = rs.getString("branch_code");
                    i++;
                }

                PreparedStatement pstmt = null;
                for(i=0; i<branch_code.length; i++)
                {
                    pstmt=con.prepareStatement("SELECT branch_name from BranchTb where branch_code = ?");
                    pstmt.setString(1, branch_code[i]);
                    rs = pstmt.executeQuery();
                    while(rs.next())
                        branch_name[i] = rs.getString("branch_name");
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
        <%
            int c2=0;

            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                    
                stmt.execute("Use Modern_Gyan_Db");

                PreparedStatement pstmt = null;
                for(int j=0; j<branch_name.length; j++)
                {
                    pstmt = con.prepareStatement("SELECT userid from StudentTb where branch_name = ?");
                    pstmt.setString(1, branch_name[j]);
                    ResultSet rs = pstmt.executeQuery();
                    while(rs.next())
                        c2+=1;
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

        <%
            i=0;
            int total_active_students=0;
            int[] active_students = new int[c];
            String[][] student_userid = new String[c][c2];

            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                    
                stmt.execute("Use Modern_Gyan_Db");

                PreparedStatement pstmt = null;
                ResultSet rs = null;

                for(int j=0; j<branch_name.length; i=0,j++)
                {
                    pstmt = con.prepareStatement("SELECT userid from StudentTb where branch_name = ?");
                    pstmt.setString(1, branch_name[j]);
                    rs = pstmt.executeQuery();
                    while(rs.next())
                    {
                        student_userid[j][i] = rs.getString("userid");
                        i++;
                    }
                }

                for(int j=0; j<student_userid.length; j++)
                {
                    for(i=0,c=0; i<student_userid[j].length; i++)
                    {
                        if(student_userid[j][i]!=null)
                        {
                            rs = stmt.executeQuery("SELECT COUNT(*) from " + student_userid[j][i] + "_courses_tb");
                            while(rs.next())
                                c=rs.getInt(1);

                            if(c!=0)
                                active_students[j] += 1;
                        }
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

            for(i=0; i<active_students.length; i++)
                total_active_students += active_students[i];
        %>

        <div id ="active_student_count">   
            <h3 id="total_active_students" onclick="DisplaySubData('Active_Students', 'active_student_count')"> Total number of Active students : <%= total_active_students %> </h3>
            <%
                for(i=0; i<branch_name.length; i++)
                {
                    %> <p class="Active_Students HiddenDetails"> <%= branch_name[i] + " : " + active_students[i] %> </p> <%
                }
            %>
        </div>

        <%-- Faculty count display --%>
        <%
            int total_faculty_count=0;
            int[] branch_faculty = null;
            String[] subject_code = null;

            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                    
                stmt.execute("Use Modern_Gyan_Db");

                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) from FacultyTb");
                while(rs.next())
                    total_faculty_count=rs.getInt(1);

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

        <div id ="faculty_count">   
            <h3> Total number of Faculties : <%= total_faculty_count %> </h3>
        </div>
    
        <%-- Admin operation buttons list --%>
        <form name="btn" id="BtnPanel">
            <input type="submit" value="Add Admin" onclick="btn.action='AddAdmin.jsp'"/>
            <input type="submit" value="Branch Insert" onclick="btn.action='BranchInsert.jsp'"/>
            <input type="submit" value="Subject Insert" onclick="btn.action='SubjectInsert.jsp'"/>
            <input type="submit" value="Topic Insert" onclick="btn.action='TopicInsert.jsp'"/>
            <input type="submit" value="Request Page" onclick="btn.action='RequestPage.jsp'"/>
        </form>
    </div>

    <%-- Faculty details display --%>
    <div id="expandIcon"> <i class="fas fa-expand" onclick="ExpandBar()"></i> </div>
    <div id="FacultyDisplay">
        <form action='../Faculty/FacultyProfile.jsp' method="POST">
        <%
            String query="";
            if(request.getParameter("txSearch")!=null)
                query = "where faculty_name like '%"+request.getParameter("txSearch")+"%' or faculty_code like '%"+request.getParameter("txSearch")+"%'";

            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                    
                stmt.execute("Use Modern_Gyan_Db");

                c=0;
                ResultSet rs = stmt.executeQuery("SELECT count(*) from FacultyTb "+ query);
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

            String[] facultycode_img = new String[c];
            String[] faculty_code = new String[c];
            String[] faculty_name = new String[c];
            String[] experience = new String[c];

            out.print("<div class='FacultyDetailsHead'> <label class='Serialno underline'> S. No. </label> <label class='FacultyHeading'>"
                + " FacultyCode_img </label> <label class='FacultyHeading'> Faculty Code </label> <label class='FacultyHeading'> Faculty Name </label>"
                + " <label class='FacultyHeading'> Experience </label> <label class='FacultyHeading'> Faculty Data </label> </div>"); 

            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                    
                stmt.execute("Use Modern_Gyan_Db");

                i=0;
                ResultSet rs = stmt.executeQuery("SELECT facultycode_img, faculty_code, faculty_name, experience from FacultyTb "+query);
                while(rs.next())
                {
                    facultycode_img[i] = rs.getString("facultycode_img");
                    faculty_code[i] = rs.getString("faculty_code");
                    faculty_name[i] = rs.getString("faculty_name");
                    experience[i] = rs.getString("experience");
                    i++;
                }

                for(i=0; i<c; i++)
                {
                    out.print("<div class='FacultyDetails'> <label class='Serialno'>"+ (i+1) +".</label> <img src='"+ facultycode_img[i] +"' name='FacultyImg"+ i +"'"
                        + " readonly/> <input type='text' name='txFacultyCode"+ i +"' value='"+ faculty_code[i] +"' readonly/> <input type='text' name='txFacultyName"+ i +"'"
                        + " value='"+ faculty_name[i] +"' readonly/> <input type='text' name='txExperience"+ i +"' value='"+ experience[i] +"' readonly/>"
                        + " <div class='DetailsBtn'> <input type='submit' name='sbDetails"+ i +"' value='Details'/> </div> </div>");
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
        </form>
    </div>
</body>
</html>