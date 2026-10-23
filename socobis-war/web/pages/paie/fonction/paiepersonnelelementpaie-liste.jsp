<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="paie.elementpaie.PaiePersonnelElementpaie"%>
<%@ page import="utilitaire.Utilitaire" %>

<%
    try {

        PaiePersonnelElementpaie dr = new PaiePersonnelElementpaie();
        dr.setNomTable("PAIE_PERS_ELTPAIE_LIB2");

        String listeCrt[] = {
                "id","matricule","code_rubrique",
                "remarque","moisregularisation","moislib","anneeregularisation",
                "date_debut","date_fin","idpersonnel"
        };

        String listeInt[] = {};

        String libEntete[] = {
                "id","matricule","idpersonnel","code_rubrique","rubriqueLib","moislib",
                "anneeregularisation","date_debut","date_fin","gain","retenue","etatlib"
        };

        PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);

        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("paie/fonction/paiepersonnelelementpaie-liste.jsp");

        String etat = request.getParameter("etat");
        if(etat != null && !etat.equals("")) {
            pr.setAWhere(" and etat " + etat);
        }

        Liste[] liste = new Liste[1];
        liste[0] = new Liste("moisregularisation");
        liste[0].makeListeMois();
        pr.getFormu().changerEnChamp(liste);

        pr.getFormu().getChamp("matricule").setLibelle("Matricule");
        pr.getFormu().getChamp("code_rubrique").setLibelle("Code rubrique");
        pr.getFormu().getChamp("idpersonnel").setLibelle("Personnel");

        pr.getFormu().getChamp("remarque").setVisible(false);
        pr.getFormu().getChamp("moislib").setVisible(false);
        pr.getFormu().getChamp("date_fin").setLibelle("Date de fin");
        pr.getFormu().getChamp("date_debut").setLibelle("Date de d&eacute;but");
//        pr.getFormu().getChamp("date_fin1").setDefaut(""+ Utilitaire.dateDuJour());
//        pr.getFormu().getChamp("date_fin2").setDefaut(""+ Utilitaire.dateDuJour());
//        pr.getFormu().getChamp("date_debut1").setLibelle("Date de d&eacute;but (min)");
//        pr.getFormu().getChamp("date_debut2").setLibelle("Date de d&eacute;but (max)");
//        pr.getFormu().getChamp("date_debut1").setDefaut(""+ Utilitaire.dateDuJour());
//        pr.getFormu().getChamp("date_debut2").setDefaut(""+ Utilitaire.dateDuJour());
        pr.getFormu().getChamp("moisregularisation").setLibelle("Mois");

        pr.getFormu().getChamp("anneeregularisation").setLibelle("Ann&eacute;e");
//        pr.getFormu().getChamp("etatLib").setVisible(false);

        pr.setTitre("Liste des &eacute;l&eacute;ments de paie");
        pr.setApres("paie/fonction/paiepersonnelelementpaie-liste.jsp");

        pr.getFormu().setAnotherButton(
                "<a class='btn btn-primary pull-right btn-small' href='module.jsp?but=paie/fonction/paiepersonnelelementpaie-saisie.jsp'>" +
                        "<i class='material-symbols-rounded'>add</i>Saisir un &eacute;l&eacute;ment de paie</a>"
        );

        pr.setNpp(500);

        pr.creerObjetPage(libEntete, null);

        String currentEtat = request.getParameter("etat");
        if(currentEtat == null || currentEtat.equals("")) {
            currentEtat = "!= 100";
        }

        boolean etatCree = "=1".equals(currentEtat);

        String formAction = pr.getLien() + "?but=" +
                (etatCree
                        ? "paie/fonction/apresPaiePersonnelElement.jsp&acte=valider"
                        : pr.getApres()
                );

        String[] etatVal = {"!= 100","=1","=11"};
        String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)","Valid&eacute;(s)"};

%>

<div class="content-wrapper">

    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>

    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>

        <!-- FILTER -->
        <form action="<%=pr.getLien()%>?but=<%=pr.getApres()%>" method="post" name="incident">

            <div class="row col-md-12 nopadding">
                <div class="col-md-2">
                    &Eacute;tat :
                <select name="etat" class="form-control" onchange="document.incident.submit()">

                    <%
                        String cur = request.getParameter("etat");
                        if(cur == null) cur = "!= 100";

                        for(int i=0;i<etatVal.length;i++){
                    %>
                    <option value="<%=etatVal[i]%>" <%=etatVal[i].equals(cur)?"selected":""%>>
                        <%=etatAff[i]%>
                    </option>
                    <% } %>

                </select>
                </div>
            </div>

        </form>

        <!-- TABLE -->
        <form action="<%=formAction%>" method="post">

            <input type="hidden" name="lien" value="<%=pr.getLien()%>">

            <%
                String[] lienTableau = {
                        pr.getLien() + "?but=paie/fonction/paiepersonnelelementpaie-fiche.jsp"
                };

                pr.getTableau().setLien(lienTableau);
                pr.getTableau().setColonneLien(new String[]{"id"});

                String[] affichage = {
                        "ID","Matricule","Personnel","Code Rubrique","Rubrique",
                        "Mois","Ann&eacute;e","Date de D&eacute;but","Date de Fin",
                        "Gain","Retenue","&Eacute;tat"
                };

                pr.getTableau().setLibelleAffiche(affichage);
            %>

            <%
                out.println(pr.getTableauRecap().getHtml());
            %>
            <%
                if(etatCree){
                    pr.setNpp(pr.getTableau().getData().length);
                    pr.getTableau().setNameBoutton("Valider");
                    out.println(pr.getTableau().getHtmlWithCheckbox());
                } else {
                    out.println(pr.getTableau().getHtml());
                }

                out.println(pr.getBasPage());
            %>

        </form>

    </section>
</div>

<script>
    document.querySelectorAll(".more_info").forEach(btn => btn.remove());
</script>

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>
