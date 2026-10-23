<%--
    Document   : apresmouvement
    Created on : 29 sept. 2022, 10:12:50
    Author     :    Sambatra Rakotondrainibe
--%>

<%@page import="utilitaire.Utilitaire"%>
<html>
<%
    String champRet =(String) request.getParameter("champReturn");
    String choix = (String) request.getParameter("choix");
    String[] champs = Utilitaire.split(champRet, ";");
    String[] lstChoix = Utilitaire.split(choix, ";");
%>
<script language="JavaScript">
    window.opener.document.all.<%=champs[0]%>.value = "<%=lstChoix[0]%>";
    var options = window.opener.$('#direction option');
    for(var co=0;co<options.size();co++){
        if(options[co].value==="<%=lstChoix[1]%>"){
            window.opener.$('#direction option')[co].selected = true;
        }else{
            window.opener.$('#direction option')[co].selected = false;
        }
    }
    window.opener.document.all.<%=champs[2]%>.value = "<%=lstChoix[2]%>";
    window.opener.document.all.servicelibelle.value = "<%=lstChoix[2]%>";
    window.opener.document.all.<%=champs[3]%>.value = "<%=lstChoix[3]%>";
    window.opener.document.all.idfonctionlibelle.value = "<%=lstChoix[3]%>";
    options = window.opener.$('#echelon option');
    for(var co=0;co<options.size();co++){
        if(options[co].innerHTML==="<%=lstChoix[4]%>"){
            window.opener.$('#echelon option')[co].selected = true;
        }else{
            window.opener.$('#echelon option')[co].selected = false;
        }
    }
    window.opener.document.all.<%=champs[5]%>.value = "<%=lstChoix[5]%>";
    window.close();
</script>
</html>