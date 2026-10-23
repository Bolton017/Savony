<%@page import="utilitaire.ConstanteEtat"%>
<%@page import="utilitaire.Constante"%>
<%@page import="paie.demande.DemandeJustifications"%>
<%@page import="affichage.*"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.*" %>

<% try{ 
    DemandeJustifications t = new DemandeJustifications();
    t.setNomTable("demande_libcomplet_final");
    String listeCrt[] = {"matricule","nom", "prenom","datedepart","datefin"};
    String listeInt[] = {"daty","datedepart","datefin"};
    String libEntete[] = {"matricule","nom", "prenom","motif","duree","daty","datedepart","datefin","dateretour"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/conge/congepris.jsp");

    pr.getFormu().getChamp("matricule").setLibelle("Matricule");  
    pr.getFormu().getChamp("nom").setLibelle("Nom");
    pr.getFormu().getChamp("prenom").setLibelle("Pr&eacute;nom");    
    pr.getFormu().getChamp("datedepart1").setLibelle("Date d&eacute;but min");
    pr.getFormu().getChamp("datedepart2").setLibelle("Date d&eacute;but  max");
    pr.getFormu().getChamp("datefin1").setLibelle("Date fin min");
    pr.getFormu().getChamp("datefin2").setLibelle("Date fin max");
      
    String[] colSomme = null;
    
    pr.creerObjetPage(libEntete, colSomme);
%>
<script>
    function changerDesignation() {
        document.personnel.submit();
    }

</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste cong&eacute; pris</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/conge/congepris.jsp" method="post" name="personnel" id="personnel">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form> 
           <% out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            String libEnteteAffiche[] = {"Matricule","Nom", "Pr&eacute;nom", "Motif", "Dur&eacute;e", "Date de saisie", "Date d&eacute;but","Date fin","Date retour"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace(); 
    }
%>
