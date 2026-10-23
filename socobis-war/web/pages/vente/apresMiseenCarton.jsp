

<%@page import="vente.BoncommandeDetailsCarton"%>
<%@page import="utils.ConstanteEtatStation"%>
<%@page import="bean.CGenUtil"%>
<%@page import="vente.Vente"%>
<%@page import="user.UserEJB"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
Connection connection = null;
try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        connection = new UtilDB().GetConn();
        String lien = (String)session.getAttribute("lien");
        String acte = request.getParameter("acte");
        String bute = request.getParameter("bute");
        String type = request.getParameter("type");
        String nomtable=request.getParameter("nomtable");
        String[] ids = request.getParameterValues("id");
        String idbc = request.getParameter("idbc");
        String chaineIds = ""; 
        if (ids == null || ids.length == 0) {
            throw new Exception("Vous devez cocher au moins une case.");
        }
        else{
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < ids.length; i++) {
                    sb.append(ids[i]);
                    if (i < ids.length - 1) {
                        sb.append(";");
                    }
                }
        chaineIds = sb.toString();
        bute = "vente/miseencarton/carton-saisie.jsp&idbc="+idbc+"&ids="+chaineIds;
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
} finally {
        if (connection != null) {
                try {
                        connection.close();
                } catch (SQLException e) {
                        e.printStackTrace();
                }
        }
}
%>