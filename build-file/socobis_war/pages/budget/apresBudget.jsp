<%@ page import="user.UserEJB" %>
<%@ page import="vente.Vente" %>
<%@ page import="prevision.Prevision" %>
<%@ page import="budget.Budget" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%

  try{
    UserEJB u = (UserEJB)session.getAttribute("u");
    String acte=request.getParameter("acte");

      String lien = (String)session.getAttribute("lien");
    String bute = request.getParameter("bute");
    String annee = request.getParameter("annee");
    String mois = request.getParameter("mois");
    String recurence = request.getParameter("recurence");
    String[] ids = request.getParameterValues("ids");
      System.out.println("======================>" +ids.length);
          if (ids.length>0) {

          Budget budget = new Budget();
          budget.dupliquerMultiple(ids,Integer.parseInt(annee),Integer.parseInt(mois),Integer.parseInt(recurence), u.getUser().getTuppleID(), null);
        }else{
          throw new Exception("Selectionner au moin une budget");
        }
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<%
}catch (Exception e) {
  e.printStackTrace();
%>

<script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
history.back();</script>
<%
    return;
  } %>