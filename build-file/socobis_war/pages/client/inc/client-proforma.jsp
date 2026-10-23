<%--
    Document   : historique.jsp
    Created on : 21 mars 2024, 15:15:01
    Author     : Angela
--%>


<%@page import="vente.VenteDetailsLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="proforma.ProformaLib" %>


<%
    try{
        ProformaLib t = new ProformaLib();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "daty", "idclientLib","idMagasinLib", "montantttc","montantTva","montantPaye","montantreste"};
//    id | desce | montantPayé | montantTTC | montantTVA
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idClient='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;

        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;
        String lienTableau[] = {pr.getLien() + "?but=vente/proforma/proforma-liste.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%

        String libEnteteAffiche[] = {"id", "date", "Client","Magasin", "montant(TTC)","montant(TVA)","montant Pay&eacute;","montant restant"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><center><h4>Aucune donne trouvé</h4></center><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>


