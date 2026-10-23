<%@page import="notification.Notification"%>
<%@page import="java.sql.Timestamp"%>
<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<html>

<% try {
    String nomtable = request.getParameter("nomtable");
    String lien = (String) session.getValue("lien");
    UserEJB u = (UserEJB) session.getAttribute("u");
    String acte = request.getParameter("acte");
    String bute = request.getParameter("bute");
    String id = request.getParameter("id");

    if (acte.compareToIgnoreCase("vu") == 0) {     // VU NOTIF
        Notification notif = new Notification();
        notif.setValChamp(notif.getAttributIDName(), request.getParameter("id"));
        notif.setNomTable(nomtable);
        notif.vu(u, null);
        %><script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=request.getParameter("ref")%>");</script><%
    }
    if (acte.compareToIgnoreCase("toutvu") == 0) {     // TOUT VU NOTIF
        Notification notif = new Notification();
        notif.setNomTable("notification2");
        String where = " and receiver = '%s' and etat = 1";
        where = String.format(where, u.getUser().getRefuser());
        System.out.println(where);
        Notification[]mesnotifs = (Notification[])CGenUtil.rechercher(notif, null, null, where);
        notif.vu(u, null, mesnotifs); %>
        <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&receiver=<%=u.getUser().getRefuser()%>");</script><%
    }
    %><script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=Utilitaire.champNull(id)%>");</script><%
} catch (Exception e) {
    e.printStackTrace(); %>
    <script language="JavaScript">
        alert("<%=e.getMessage()%>");
        history.back();
    </script>
<% return;}%>
</html>