<%@page import="utils.ConstanteEtatStation"%>
<%@page import="bean.CGenUtil"%>
<%@page import="user.UserEJB"%>
<%@page import="user.UserEJBBean"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page import="mg.cnaps.compta.ComptaLettrage" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        String lien = (String)session.getAttribute("lien");
        String acte = request.getParameter("acte");
        String bute = "compta/lettrage/lettrage-fiche.jsp";
        String type = request.getParameter("type");
        String nomtable=request.getParameter("nomtable");
        String lettre = request.getParameter("lettre");
        System.out.println("lettree "+lettre);
        String[] ids = request.getParameterValues("ids");
        ComptaLettrage cl = new ComptaLettrage();

        if(ids==null || ids.length==0){
            throw new Exception("Vous devez cocher");
        }

        cl = cl.createLettrageCSEMF(ids, lettre, u.getUser().getTuppleID(),null);

%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=cl.getId()%>");</script>
<%
}catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
history.back();</script>
<%
        return;
    }
%>
