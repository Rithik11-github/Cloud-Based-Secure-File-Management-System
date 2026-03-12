<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin - Security Question Upload</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:'Poppins',sans-serif;
}

body{
background: linear-gradient(120deg,#4facfe,#00f2fe);
min-height:100vh;
}

/* NAVBAR */

nav{
background:rgba(0,0,0,0.85);
padding:15px 30px;
box-shadow:0 4px 10px rgba(0,0,0,0.2);
}

nav ul{
list-style:none;
display:flex;
align-items:center;
}

nav ul li a{
color:white;
text-decoration:none;
font-size:16px;
font-weight:500;
padding:8px 15px;
border-radius:6px;
transition:.3s;
}

/* Back Button Style */

.back-btn{
background:#00c6ff;
display:inline-flex;
align-items:center;
gap:6px;
}

.back-btn:hover{
background:#0096c7;
transform:translateX(-3px);
}

/* CONTAINER */

.container{
width:90%;
max-width:1000px;
margin:60px auto;
background:white;
padding:40px;
border-radius:10px;
box-shadow:0 10px 30px rgba(0,0,0,0.2);
animation:fadeIn .6s ease;
}

@keyframes fadeIn{
from{opacity:0;transform:translateY(20px);}
to{opacity:1;transform:translateY(0);}
}

h1{
text-align:center;
margin-bottom:30px;
color:#333;
font-weight:600;
}

/* INPUT FIELD */

.input-group{
margin-bottom:25px;
}

.input-group label{
font-weight:500;
display:block;
margin-bottom:8px;
color:#444;
}

.input-group input{
width:100%;
padding:12px;
border-radius:6px;
border:1px solid #ccc;
font-size:14px;
transition:.3s;
}

.input-group input:focus{
border-color:#4facfe;
box-shadow:0 0 5px rgba(79,172,254,.5);
outline:none;
}

/* TABLE */

table{
width:100%;
border-collapse:collapse;
margin-top:10px;
}

table th,table td{
padding:12px;
border-bottom:1px solid #eee;
}

table tr:hover{
background:#f7fbff;
}

/* SELECT */

select{
width:100%;
padding:10px;
border-radius:5px;
border:1px solid #ccc;
transition:.3s;
}

select:focus{
border-color:#4facfe;
outline:none;
}

/* ANSWER INPUT */

td input{
width:100%;
padding:10px;
border-radius:5px;
border:1px solid #ccc;
transition:.3s;
}

td input:focus{
border-color:#4facfe;
outline:none;
}

/* BUTTON */

.submit-btn{
margin-top:25px;
width:100%;
padding:14px;
border:none;
border-radius:6px;
background:linear-gradient(45deg,#4facfe,#00f2fe);
color:white;
font-size:16px;
font-weight:500;
cursor:pointer;
transition:.3s;
}

.submit-btn:hover{
transform:translateY(-2px);
box-shadow:0 8px 20px rgba(0,0,0,.2);
}

/* RESPONSIVE */

@media(max-width:768px){

.container{
padding:25px;
}

table th,table td{
font-size:13px;
}

}

</style>

<script>

const questions = [
"What was the name of your first pet?",
"What is your favorite color?",
"What was the name of your elementary school?",
"What is the name of the city you were born in?",
"What is your mother's maiden name?",
"What is your father's name?",
"What was the name of your first car?",
"What is the name of your best friend?",
"Where did you meet your spouse?",
"What is the name of the street you grew up on?",
"What was your childhood nickname?",
"What was the make and model of your first car?",
"What is your favorite childhood memory?",
"What was the name of your first teacher?",
"What is your favorite book?",
"What is your father's middle name?",
"What city did you grow up in?",
"What was the name of your childhood friend?",
"What is your favorite sport?",
"What was your first job?"
];

function updateQuestionOptions(){

const selects=document.querySelectorAll('select');
const selected=[];

selects.forEach(s=>{
if(s.value) selected.push(s.value);
});

selects.forEach(select=>{

select.querySelectorAll('option').forEach(option=>{

if(selected.includes(option.value) && option.value!==select.value){
option.style.display='none';
}else{
option.style.display='block';
}

});

});

}

window.onload=function(){

const table=document.getElementById("questions-table");

for(let i=0;i<10;i++){

let row=document.createElement("tr");

let td1=document.createElement("td");
td1.innerHTML="<b>Q"+(i+1)+"</b>";

let td2=document.createElement("td");
let select=document.createElement("select");
select.name="question_"+(i+1);
select.required=true;

let def=document.createElement("option");
def.text="Select a security question";
def.disabled=true;
def.selected=true;
def.value="";
select.appendChild(def);

questions.forEach(q=>{
let op=document.createElement("option");
op.value=q;
op.text=q;
select.appendChild(op);
});

select.addEventListener("change",updateQuestionOptions);

td2.appendChild(select);

let td3=document.createElement("td");

let input=document.createElement("input");
input.type="text";
input.name="answer_"+(i+1);
input.placeholder="Enter your answer";
input.required=true;

td3.appendChild(input);

row.appendChild(td1);
row.appendChild(td2);
row.appendChild(td3);

table.appendChild(row);

}

updateQuestionOptions();

}

</script>

</head>

<body>

<%
String msg=(String)session.getAttribute("msg");
if(msg!=null){
%>

<script>
alert("<%=msg%>");
</script>

<%
session.removeAttribute("msg");
}
%>

<nav>
<ul>
<li>
<a href="user.jsp" class="back-btn">← Back</a>
</li>
</ul>
</nav>

<div class="container">

<h1>Upload Security Questions</h1>

<form action="QUESTION_ANS" method="POST">

<div class="input-group">
<label>Enter Aadhaar Card Number</label>
<input type="text" name="aadhar_no" placeholder="Enter Aadhaar Number" required>
</div>

<table id="questions-table"></table>

<input type="submit" value="Submit Questions" class="submit-btn">

</form>

</div>

</body>
</html>