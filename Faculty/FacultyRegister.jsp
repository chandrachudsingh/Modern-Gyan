<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Faculty Register | Modern-Gyan</title>

    <link rel="stylesheet" href="FacultyRegister.css">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>
    
    <script>
        function DisableSubmit()
        {
            document.getElementById("btSubmit").disabled="disabled";
            document.getElementById("btSubmit").style.cursor="not-allowed";

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

            if(document.getElementById("faculty_name").value!="" && document.getElementById("faculty_code").value!="" &&
            document.getElementById("dob").value!="" && flag==1 &&
            document.getElementById("qualification").value!="" && document.getElementById("experience").value!="" && 
            document.getElementById("address").value!="" && document.getElementById("mobile").value!="" && 
            document.getElementById("email").value!="" && document.getElementById("profession").value!="" &&
            document.getElementById("fac_img").value!="" && document.getElementById("code_img").value!="" &&
            document.getElementById("password").value!="")
            {
                document.getElementById("btSubmit").disabled="";
                document.getElementById("btSubmit").style.cursor="not-allowed";
            }
            else
            {
                document.getElementById("btSubmit").disabled="disabled";
                document.getElementById("btSubmit").style.cursor="pointer";
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
    <h4 id=WorkHead>Personal Information & Profile</h4>
    <form action="FacultyRegisterBack.jsp" method="POST" id="FacultyRegisterForm">
        <div id="FacultyDetails">
            <table>
                <tr>
                    <th><label for="faculty_code">Faculty Code</label></th><td class="colon">:</td>
                    <td><input type="text" name="txFacultyCode" id="faculty_code" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="faculty_name">Faculty Name</label></th><td class="colon">:</td>
                    <td><input type="text" name="txFacultyName" id="faculty_name" onchange="EnableSubmit()"></td>
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
                    <th><label for="qualification">Qualification</label></th><td class="colon">:</td>
                    <td><textarea name="tQual" id="qualification" onchange="EnableSubmit()"></textarea></td>
                </tr>
                <tr>
                    <th><label for="experience">Experience</label></th><td class="colon">:</td>
                    <td><textarea name="tExp" id="experience" onchange="EnableSubmit()"></textarea></td>
                </tr>
                <tr>
                    <th><label for="address">Address</label></th><td class="colon">:</td>
                    <td><textarea name="tAddress" id="address" onchange="EnableSubmit()"></textarea></td>
                </tr>
            </table>
            <table>
                <tr>
                    <th><label for="mobile">Mobile No</label></th><td class="colon">:</td>
                    <td><input type="tel" name="txMobile" id="mobile" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="email">Email</label></th><td class="colon">:</td>
                    <td><input type="email" name="txEmail" id="email" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="profession">Current Profession</label></th><td class="colon">:</td>
                    <td><textarea name="tProf" id="profession" onchange="EnableSubmit()"></textarea></td>
                </tr>
                <tr class="FacultyImagePanel">
                    <th><label for="fac_img">Faculty Image</label></th><td class="colon">:</td>
                    <td class="FacultyImageChoose">
                        <span><input type="file" name="fileFac_Img" id="fac_img"  onchange="EnableSubmit()" oninput="DisplayImg(0,'fac_img')"> 
                            <label id="lbFacultyImg" onclick="ClickInputFile('fac_img')"> <i class="fa fa-upload"></i> Browse image </label></span>
                        <span><img src="" id="FacultyImage"/></span>
                    </td>
                </tr>
                <tr class="FacultyImagePanel">
                    <th><label for="code_img">Code Image</label></th><td class="colon">:</td>
                    <td class="FacultyImageChoose">
                        <span> <input type="file" name="fileCode_Img" id="code_img" onchange="EnableSubmit()" oninput="DisplayImg(1,'code_img')"> 
                            <label id="lbCodeImg" onclick="ClickInputFile('code_img')"> <i class="fa fa-upload"></i> Browse image </label></span>
                        <span><img src="" id="CodeImage"/></span>
                    </td>
                </tr>
                <tr>
                    <th><label for="password">Enter Password</label></th><td class="colon">:</td>
                    <td><input type="password" name="txPassword" id="password" onchange="EnableSubmit()"></td>
                </tr>
            </table>
        </div>

        <div id="SubmitBtn"> <input type="submit" id="btSubmit" value="Submit"> </div>
    </form>
</body>
</html>