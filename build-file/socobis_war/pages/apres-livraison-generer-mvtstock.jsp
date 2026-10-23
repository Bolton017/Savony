<%@page import="stock.MvtStock"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="user.UserEJB"%>
<%@ page import="vente.As_BondeLivraisonClient" %>
<%@page import="faturefournisseur.As_BonDeLivraison"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="utilitaire.UtilDB" %>
<%@ page import="java.sql.SQLException" %>
<%
    try {
        String lien = (String) session.getAttribute("lien");
        UserEJB u = u = (UserEJB) session.getValue("u");
        String redirection = "stock/mvtstock-fiche.jsp";
        System.out.println("lien : " + lien);
        String idBLF = request.getParameter("idBLF");
        String idBLC = request.getParameter("idBLC");
        MvtStock mvtStock = null;

        if(idBLF!=null && !idBLF.isEmpty()) {
            System.out.println("idBLF : " + idBLF);
            As_BonDeLivraison bl = new As_BonDeLivraison();
            bl.setId(idBLF);
            mvtStock = bl.genererMvtStockPersist1(u.getUser().getTuppleID());
            System.out.println("mvtStock : " + mvtStock);
        }
        if(idBLC!=null && !idBLC.isEmpty()){
            System.out.println("idBLC : " + idBLC);
            As_BondeLivraisonClient bl = new As_BondeLivraisonClient();
            bl.setId(idBLC);
            mvtStock = bl.genererMvtStock(null);
            System.out.println("mvtStock : " + mvtStock);
        }

        if (mvtStock != null) {
            MvtStock createdMvtStock = (MvtStock) u.createObjectMultiple(mvtStock, mvtStock.getLiaisonFille(), mvtStock.getFille());
            u.validerObject(createdMvtStock);
            %>
                <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=redirection%>&id=<%=createdMvtStock.getId()%>");</script>
            <%
        }
        else {
            throw new RuntimeException("Aucun mouvement de stock n'a été généré.");
        }
} catch (Exception e) { e.printStackTrace(); %>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% } %>
