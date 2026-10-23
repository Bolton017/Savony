<%-- 
    Document   : paierubrique-liste
    Created on : 28 mai. 2025, 09:35:22
    Author     : jocelyn
--%>
<%@page import="paie.employe.PaieRubrique"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.*"%>
<%@page import="affichage.*"%>

<% try{
    
    PaieRubrique paie = new PaieRubrique();
    
    String listeCrt[] = {"id","val","remarque","typerubrique","imposable","nature"};
    String listeInt[] = {};
    String libEntete[] = {"id","val","remarque","code","typerubrique","imposable","nature"};
    PageRecherche pr = new PageRecherche(paie, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/rubrique/paierubrique-liste.jsp");

    affichage.Champ[] liste = new affichage.Champ[3];
    Liste l1 = new Liste("typerubrique");
    String a1[] = {"Gain", "Retenue"};
    String v1[] = {"G", "R"};
    l1.setValeurBrute(a1);
    l1.setColValeurBrute(v1);
    liste[0] = l1;

    Liste l4 = new Liste("imposable");
    String a4[] = {"Non", "Oui"};
    String v4[] = {"", "I"};
    l4.setValeurBrute(a4);
    l4.setColValeurBrute(v4);
    liste[1] = l4;

    Liste l5 = new Liste("nature");
    String a5[] = {"Fixe", "Variable"};
    String v5[] = {"fixe", "variable"};
    l5.setValeurBrute(a5);
    l5.setColValeurBrute(v5);
    liste[2] = l5;

    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("val").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("typerubrique").setLibelle("Type de rubrique");
    pr.getFormu().getChamp("remarque").setLibelle("Remarque");
    pr.getFormu().getChamp("nature").setLibelle("Nature");
    pr.getFormu().getChamp("Imposable").setLibelle("Imposable");


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
        pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=paie/rubrique/paierubrique-saisie.jsp&currentMenu=MD00000993003\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir un rubrique de paie" +
            "                </a>"
    );
%>
<script>
    function changerDesignation() {
        document.travaux.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des rubriques de paie</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/rubrique/paierubrique-liste.jsp" method="post" name="marche" id="marche">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
           
        </form>
        <%
            String lienTableau[] = {pr.getLien() + "?but=paie/rubrique/paierubrique-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            String libEnteteAffiche[] = {"Id","D&eacute;signation","Remarque","Code","Type de rubrique","Imposable","Nature"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
     <%
    }catch(Exception e){
        e.printStackTrace();
    }
%>