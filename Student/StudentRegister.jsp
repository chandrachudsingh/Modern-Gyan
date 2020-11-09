<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Student Data | Modern-Gyan</title>
    
    <link rel="stylesheet" href="StudentRegister.css">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

    <script>
        function DisableSubmit()
        {
            document.getElementById("btRegister").disabled="disabled";
            document.getElementById("btRegister").style.cursor="not-allowed";

            for(var i=0; i<document.getElementsByTagName("img").length; i++)
                document.getElementsByTagName("img").item(i).style.visibility="hidden";
        }

        function EnableSubmit()
        {
            var flag=0;
            for(var i=0; i<document.getElementsByName("rbGender").length; i++)
            {
                if(document.getElementsByName("rbGender").item(i).checked==true)
                {
                    flag=1;
                    break;
                }    
            }

            if(document.getElementById("student_name").value!="" && document.getElementById("age").value!="" &&
            document.getElementById("dob").value!="" && flag==1 && document.getElementById("email").value!="" &&
            document.getElementById("college").value!="" && document.getElementById("semester").selectedIndex!=0 &&
            document.getElementById("city").value!="" && document.getElementById("country").value!="" &&
            document.getElementById("proof").selectedIndex!=0 && document.getElementById("proof_doc").value!="" &&
            document.getElementById("user").value!="" && document.getElementById("password").value!="")
            {
                document.getElementById("btRegister").disabled="";
                document.getElementById("btRegister").style.cursor="pointer";
            }
            else
            {
                document.getElementById("btRegister").disabled="disabled";
                document.getElementById("btRegister").style.cursor="not-allowed";
            }
        }

        function DisplayImg(index, id)
        {
            var path = (document.getElementById(id).value).replace("C:\\fakepath\\", "");      //replaces the provided string with the required one
            document.getElementsByTagName("img").item(index).style.visibility="visible";
            document.getElementsByTagName("img").item(index).src = "../Images/"+ path;
        }
        
        function ClickInputFile(id)
        {
            document.getElementById(id).click();
        }
    </script>
</head>
<body onload="DisableSubmit()">

    <span id="SiteName" title="Modern-Gyan"> Modern-Gyan </span>
    <h4 id="WorkHead">Student Information</h4>
    <form action="StudentRegisterBack.jsp" method="POST" id="StudentRegisterForm">
        <div id="StudentDetails">
            <table>
                <tr>
                    <th><label for="student_name">Name</label></th><td class="colon">:</td>
                    <td><input type="text" name="txStudentName" id="student_name" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="age">Age</label></th><td class="colon">:</td>
                    <td><input type="number" name="txAge" id="age" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="dob">DOB</label></th><td class="colon">:</td>
                    <td><input type="date" name="DOB" id="dob" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th>Gender</th><td class="colon">:</td>
                    <td id="GenderValue">
                        <span><input type="radio" name="rbGender" value="Male" id="male" onchange="EnableSubmit()"> <label for="male">Male</label></span>
                        <span><input type="radio" name="rbGender" value="Female" id="female" onchange="EnableSubmit()"> <label for="female">Female</label></span>
                    </td>
                </tr>
                <tr>
                    <th><label for="email">Email</label></th><td class="colon">:</td>
                    <td><input type="email" name="txEmail" id="email" onchange="EnableSubmit()"></td>
                </tr>
                </tr>
                <tr>
                    <th><label for="college">College</label></th><td class="colon">:</td>
                    <td><textarea name="txCollege" id="college" onchange="EnableSubmit()"></textarea></td>
                </tr>
                <tr>
                    <th><label for="semester">Semester</label></th><td class="colon">:</td>
                    <td>
                        <select name="cbSem" id="semester" onchange="EnableSubmit()">
                            <option value="-1">Select Semester</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                            <option value="6">6</option>
                            <option value="7">7</option>
                            <option value="8">8</option>
                        </select>
                    </td>
                </tr>
            </table>
            <table>
                </tr>
                <tr>
                    <th><label for="city">City</label></th><td class="colon">:</td>
                    <td><input type="text" name="txCity" id="city" onchange="EnableSubmit()"></td>
                </tr>
                </tr>
                <tr>
                    <th><label for="country">Country</label></th><td class="colon">:</td>
                    <td><input type="text" name="txCountry" id="country" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="branch">Branch</label></th><td class="colon">:</td>
                    <td>
                        <select name="cbBranch" id="branch" onchange="EnableSubmit()">
                            <option value="-1">Select your branch</option>
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
                                        + "branch_code varchar(50), branch_name varchar(50))");

                                ResultSet rs=stmt.executeQuery("select distinct branch_name from BranchTb");
                                String opt="";
                                while(rs.next())
                                {
                                    opt=rs.getString("branch_name");
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
                <tr>
                    <th><label for="proof">Proof Type</label></th><td class="colon">:</td>
                    <td>
                        <select name="cbProof" id="proof" onchange="EnableSubmit()">
                            <option value="-1">Select Proof item</option>
                            <option value="Aadhar card">Aadhar card</option>
                            <option value="Pan card">Pan card</option>
                            <option value="Voter Id">Voter Id</option>
                        </select>
                </tr>
                <tr class="ProofImagePanel">
                    <th><label for="proof_doc">Upload Proof document</label></th><td class="colon">:</td>
                    <td class="ProofFileChoose">
                        <input type="file" name="fileProof_Img" id="proof_doc" onchange="EnableSubmit()" oninput="DisplayImg(0,'proof_doc')">
                        <label id="lbProofFile" onclick="ClickInputFile('proof_doc')"> <i class="fa fa-upload"></i> Browse image </label></span>
                        <span><img src="" id="ProofFile"/></span>
                    </td>
                </tr>
                <tr>
                    <th><label for="user">Enter username</label></th><td class="colon">:</td>
                    <td><input type="text" name="txUser" id="user" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="password">Enter Password</label></th><td class="colon">:</td>
                    <td><input type="password" name="txPassword" id="password" onchange="EnableSubmit()"></td>
                </tr>
            </table>
        </div>

        <div id="RegisterBtn"> <input type="submit" id="btRegister" value="Register"> </div>
    </form>

</body>
</html>