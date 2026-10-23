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
<%@ page import="vente.VenteCplVisee" %>


<%
    try{
        VenteCplVisee t = new VenteCplVisee();
        t.setNomTable("VENTE_CPL_BC_VISEE");
        String listeCrt[] = {};
        String listeInt[] = {};
        String[] libEntete = {"id", "designation","idClientLib","idDevise","referencefacture","daty","montantttc","montantRevient","margeBrute","montantpaye", "montantreste","etatlib","datyprevu"};
        String[] libEnteteAffiche = {"id", "D&eacute;signation","Client","devise","R&eacute;f&eacute;rence facture","Date","Montant TTC","Montant de revient","marge Brute","Montant Pay&eacute;","Montant restant","&Eacute;tat","&Eacute;ch&eacute;ance"};

//    id | desce | montantPayé | montantTTC | montantTVA
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));



        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idClient='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;

        pr.creerObjetPage(libEntete, colSomme);

        String lienTableau[] = {pr.getLien() + "?but=vente/vente-liste.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);

        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
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


