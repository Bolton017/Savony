<%@ page import="fabrication.BcGroupeIng" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="user.UserEJB" %>
<%@ page import="fabrication.Of" %><%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 2025-04-30
  Time: 10:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String[] ids = request.getParameterValues("id");
    UserEJB u = null;
    String lien = null;
    String bute;
    String idmere;
    System.out.println(request.getParameterValues("id").length);
    try {
        for (int i = 0; i < ids.length; i++) {
            System.out.print("IDS = "+ids[i]);
        }
        u = (UserEJB) session.getAttribute("u");
        String user = String.valueOf(u.getUser().getRefuser());
        Of of = new BcGroupeIng().traiterBcGroupe(ids,user,null);
        lien = (String) session.getValue("lien");
        bute = request.getParameter("bute");
        idmere = of.getId();
%>
        <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
<%
    } catch (Exception e) {
        e.printStackTrace();
%>
        <script language="JavaScript">
            alert('<%=e.getMessage()%>');
            history.back();
        </script>
<%
    }

%>