<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="paie.avance.Remboursement"%>
<%@page import="affichage.PageRecherche"%>

<%
    try{
        Remboursement lv = new Remboursement();
        lv.setNomTable("Remboursementlib");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] ={"id","personnel","mois", "annee", "montant","etatlib"};
        PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setAWhere(" and idavance='"+request.getParameter("idavance")+"'");
        pr.setApres("paie/avance/remboursement-liste.jsp");
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);%>
<script>
    function changerDesignation() {
        document.listeRemboursement.submit();
    }
</script>
<div class="box-body">
        <%
            String libEnteteAffiche[] =  {"R&eacute;f&eacute;rence","Personnel","Mois", "Annee", "Montant","Etat"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
        %>
</div>
<%
    }catch(Exception ex){
        ex.printStackTrace();
    }

%>