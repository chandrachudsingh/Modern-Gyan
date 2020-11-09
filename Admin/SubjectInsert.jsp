<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Subject Insert | Modern-Gyan</title>

    <link rel="stylesheet" href="SubjectInsert.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

    <script>
        function DisableSubmit()
        {
            document.getElementById("btSubjectInsert").disabled="disabled";
            document.getElementById("btSubjectInsert").style.cursor="not-allowed";

            document.getElementById("sub_code").focus();
        }

        function EnableSubmit()
        {
            if(document.getElementById("sub_code").value!="" && document.getElementById("sub_name").value!="" && 
            document.getElementById("fees").value!="" && document.getElementById("br_code").selectedIndex!=0)
            {
                document.getElementById("btSubjectInsert").disabled="";
                document.getElementById("btSubjectInsert").style.cursor="pointer";
            }
        }
    </script>
</head>
<body onload="DisableSubmit()">

    <%-- Site Header --%>
    <jsp:include page="AdminSiteHeader.jsp"/>

    <!-- Subject Insert form -->
    <div id="SubjectInsertPanel">
        <h4 id="WorkHead">Insert Subject</h4>
        <form action="SubjectInsertBack.jsp">
            <table>
                <tr>
                    <th><label for="sub_code">Subject Code</label></th><td class="colon">:</td>
                    <td><input type="text" name="txSubCode" id="sub_code" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="sub_name">Subject Name</label></th><td class="colon">:</td>
                    <td><input type="text" name="txSubName" id="sub_name" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="fees">Fees</label></th><td class="colon">:</td>
                    <td><input type="text" name="txFees" id="fees" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="duration">Duration</label></th><td class="colon">:</td>
                    <td><input type="number" name="txDuration" id="duration" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="br_code">Branch Code</label></th><td class="colon">:</td>
                    <td>
                        <select name="cbBranchCode" id="br_code" onchange="EnableSubmit()">
                            <option value="-1">Select branch code</option>
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
                                stmt.executeUpdate("Create table if not exists BranchTb(branch_id int auto_increment primary key,"
                                        + "branch_code varchar(50) unique, branch_name varchar(50) unique)");

                                ResultSet rs=stmt.executeQuery("select distinct branch_code from BranchTb");
                                String opt="";
                                while(rs.next())
                                {
                                    opt=rs.getString("branch_code");
                                    out.print("<option value='"+opt+"'>"+opt+"</option>");
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
                    </td>
                </tr>
            </table>
            <div id="SubjectInsertBtn"> <input type="submit" id="btSubjectInsert" value="Add Subject"> </div>
        </form>
    </div>

    
    <%-- Success Message --%>
    <div id="SuccessMessage"> <label id="lbMessage">  </label> </div>
    <%
        if((String) application.getAttribute("status") != null)
        {
            %><script> 
                document.getElementById("lbMessage").style.visibility="visible"; 
                document.getElementById("lbMessage").innerHTML = "Admin added successfully <i class='fas fa-check'></i>";
                window.setTimeout('document.getElementById("lbMessage").style.opacity="0"; document.getElementById("lbMessage").style.visibility="hidden";',4000);
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