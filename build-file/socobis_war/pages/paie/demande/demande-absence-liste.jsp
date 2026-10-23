 <%@page import="utilitaire.ConstanteEtatPaie"%>
<%@page import="utils.ConstantePaie"%>
<%@page import="paie.demande.DemandeJustifications"%>
<%@page import="paie.demande.*"%>
<%@page import="affichage.*"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.*" %>
 <%@ page import="historique.MapUtilisateur" %>

 <% try{
    DemandeJustifications t = new DemandeJustifications();
    t.setNomTable("demande_libcomplet");
    String listeCrt[] = {"idpersonnel", "nom", "prenom", "matricule", "datedepart","datefin","idtypeabsence"};
    String listeInt[] = {"daty","datedepart","datefin"};
    String libEntete[] = {"id","idpersonnel","matricule","nom","prenom","motif","typeabsencelib","duree","daty","datedepart","datefin","dateretour","etatlib","annuler"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/demande/demande-absence-liste.jsp");
    affichage.Champ[] liste = new affichage.Champ[1];
    TypeObjet tp = new TypeObjet();
    tp.setNomTable("typeabsence");
    Liste l = new Liste("idtypeabsence", tp, "desce", "id");    
    liste[0] = l;
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("idtypeabsence").setLibelle("Type d'absence");
    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("nom").setLibelle("Nom");
    pr.getFormu().getChamp("prenom").setLibelle("Pr&eacute;nom");    
    pr.getFormu().getChamp("datedepart1").setLibelle("Date d&eacute;part min");
    pr.getFormu().getChamp("datedepart2").setLibelle("Date d&eacute;part  max");
    pr.getFormu().getChamp("datefin1").setLibelle("Date retour min");
    pr.getFormu().getChamp("datefin2").setLibelle("Date retour max");
    pr.getFormu().getChamp("idpersonnel").setLibelle("ID Personnel");

    EmployeComplet pers = new EmployeComplet();
    EmployeComplet e = pers.getEmployeByRefUser(pr.getUtilisateur().getUser().getRefuser()+"");
    String idP = e.getId();
//    String aWhere = " and idtypedemande like '"+ConstantePaie.idDemandeAbsence+"' or ( idSup = '"+idP+"') order by daty desc";
    String aWhere = " ";
    pr.setAWhere(aWhere);
    if(request.getParameter("etat")!=null&&request.getParameter("etat").compareTo("")!=0&&request.getParameter("etat").compareTo("null")!=0){
        pr.setAWhere(pr.getAWhere()+" and etat="+request.getParameter("etat"));
    }
     UserEJB ue = (UserEJB) session.getValue("u");
     EmployeComplet employeComplet = new EmployeComplet();
     MapUtilisateur mapUser = ue.getUser();

     if(mapUser.getIdrole().compareToIgnoreCase("agent")==0) {
         EmployeComplet emp = employeComplet.getEmployeByRefUser(mapUser.getTuppleID());
         pr.getFormu().getChamp("idpersonnel").setDefaut(emp.getId());
     }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
        pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=paie/demande/mademande.jsp&currentMenu=JUIK003\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir une demande d'abscence" +
            "                </a>"
    );

    String[] etatVal = {
        "",
        ConstanteEtatPaie.getEtatCreer()+"",
        ConstanteEtatPaie.getEtatValiderParDemandeur()+"",
        ConstanteEtatPaie.getEtatValiderParRH()+"",
        ConstanteEtatPaie.getEtatValiderParCH()+"",
        ConstanteEtatPaie.getEtatValiderParDE()+"",
        ConstanteEtatPaie.getEtatValiderParDG()+""
    };
    String[] etatAff = {
        "Tous",
        "Cr&eacute;e",
        "Valider par demandeur",
        "Valider par RH",
        "Valider par CH",
        "Valider par DE",
        "Valider par DG"
    };
%>
<script>
    function changerDesignation() {
        document.personnel.submit();
    }

</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste de demande d'absence</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/demande/demande-absence-liste.jsp" method="post" name="personnel" id="personnel">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <%
                            String currentEtat = request.getParameter("etat");
                            if (currentEtat == null) {
                                currentEtat = "";
                            }
                            for( int i = 0; i < etatAff.length; i++ ){ %>
                        <% if(etatVal[i].equalsIgnoreCase(currentEtat)) {%>
                        <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                        <% } else { %>
                        <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                        <% } %>
                        <%    }
                        %>
                    </select>
                </div>
            </div>
            <div class="col-md-4"></div>
        </form>
        <%
            String lienTableau[] = {pr.getLien() + "?but=paie/demande" + "/demande-absence-fiche.jsp",pr.getLien() + "?but=paie/employe" + "/personnel-fiche-portrait.jsp"};
            String colonneLien[] = {"id","idpersonnel"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            String libEnteteAffiche[] = {"Id","Id Personnel", "Matricule","Nom", "Pr&eacute;nom", "Motif", "Type absence", "dur&eacute;e", "Date de saisie", "Date d&eacute;but","Date fin","Date retour" , "Etat","Annul&eacute;"};
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
