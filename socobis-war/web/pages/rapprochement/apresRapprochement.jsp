<%@page import="user.UserEJB"%>
<%@ page import="rapprochement.RapprochementBC" %>
<%@ page import="rapprochement.RapprochementDBMere" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
  try{
    UserEJB u = (UserEJB)session.getAttribute("u");
    String lien = (String)session.getAttribute("lien");
    String bute = request.getParameter("bute");
    String principal = request.getParameter("principal");

    String[] ids =  request.getParameterValues("ids");
    String[] ids2 =  request.getParameterValues("ids2");

    boolean ids2Invalid = ids2 == null || ids2.length == 0 || (ids2.length == 1 && "null".equalsIgnoreCase(ids2[0]));
    if (ids2Invalid){
      session.setAttribute("ids", ids);
    } else {
      session.removeAttribute("ids");
      String[] idEcriture = ids;
      String[] idRelever = ids2;
      if (principal!=null && principal.compareToIgnoreCase("RELEVER") == 0){
        idRelever = ids;
        idEcriture = ids2;
      }
      RapprochementDBMere mere = new RapprochementDBMere();
      mere.rapprochement(u.getUser().getTuppleID(), idEcriture, idRelever,null);

      //RapprochementBC rb = new RapprochementBC();
      //rb.rapprochement(u.getUser().getTuppleID(), idEcriture, idRelever,null);
      bute = "rapprochement/liste-rapprochement.jsp";
    }
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript">
  alert('<%=e.getMessage()%>');
  history.back();
</script>
<% } %>

