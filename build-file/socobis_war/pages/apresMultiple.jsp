<%--
    Document   : apresMultiple
    Created on : Oct 19, 2018, 2:55:36 PM
    Author     : Jerry
--%>
<%@page import="constante.ConstanteEtat"%>
<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Date" %>
<%@ page import="affichage.*" %>
<%@ page import="facture.tr.Traite" %>
<%@ page import="faturefournisseur.FactureFournisseur" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.PaiementInfo" %>
<%@ page import="java.util.Map" %>
<%@ page import="vente.Vente" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <%!
        UserEJB u = null;
        String acte = null;
        String lien = null;
        String bute;
        String nomtable = null;
        String typeBoutton;
        String ben;
        String[] tId;

    %>
    <%
        try {
            ben = request.getParameter("nomtable");
            nomtable = request.getParameter("nomtable");
            typeBoutton = request.getParameter("type");
            lien = (String) session.getValue("lien");
            u = (UserEJB) session.getAttribute("u");
            acte = request.getParameter("acte");
            bute = request.getParameter("bute");
            String declencherImpression = "false";

            Object temp = null;
            String[] rajoutLien = null;
            String classe = request.getParameter("classe");
            ClassMAPTable t = null;
            String tempRajout = request.getParameter("rajoutLien");
            String val = "";
            String id = request.getParameter("id");
            tId = request.getParameterValues("ids");
            String aretourner = request.getParameter("aretourner");
            if(aretourner==null || aretourner.equals("")){
                aretourner = "0";
            }

            String nombreLigneS = request.getParameter("nombreLigne");
            int nombreLigne = Utilitaire.stringToInt(nombreLigneS);

            ClassMAPTable classTemp = (ClassMAPTable) (Class.forName(classe).newInstance());
            if (acte.equalsIgnoreCase("insert") && request.getParameter(classTemp.getAttributIDName())!=null && !request.getParameter(classTemp.getAttributIDName()).isEmpty())
            {
                acte = "updateInsert";
            }

            String idmere = request.getParameter("idmere");
            String classefille = request.getParameter("classefille");
            ClassMAPTable mere = null;
            ClassMAPTable fille = null;
            String colonneMere = request.getParameter("colonneMere");
            String nombreDeLigne = request.getParameter("nombreLigne");
            int nbLine = Utilitaire.stringToInt(nombreDeLigne);


            String rajoutLie = "";
            if (tempRajout != null && tempRajout.compareToIgnoreCase("") != 0) {
                rajoutLien = utilitaire.Utilitaire.split(tempRajout, "-");
            }
            if (bute == null || bute.compareToIgnoreCase("") == 0) {
                bute = "pub/Pub.jsp";
            }

            if (classe == null || classe.compareToIgnoreCase("") == 0) {
                classe = "pub.Montant";
            }

            if (typeBoutton == null || typeBoutton.compareToIgnoreCase("") == 0) {
                typeBoutton = "3"; //par defaut modifier
            }

            String action = request.getParameter("action");
            System.out.println("Action: "+action);
            if (action != null && action.compareToIgnoreCase("viserLivrer") == 0) {
                mere = (ClassMAPTable) (Class.forName(classe).newInstance());
                fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
                PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
                System.out.println("ato ehhhhh 1");
                String reference = request.getParameter("referencePaiement");
                String modePaiement = request.getParameter("payment-method");

                idmere = Vente.enregistrerViserLivrer(u,p,nomtable,colonneMere,modePaiement,reference);
                System.out.println("ato ehhhhh 22");

                System.err.println(idmere);
            %>
            <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
            <%
                    return;
                }

                if (action != null && action.compareToIgnoreCase("viserLivrerEncaisser") == 0) {
//                    mere = (ClassMAPTable) (Class.forName(classe).newInstance());
//                    fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
//                    boolean isMultiple = "true".equals(request.getParameter("multiplePayment"));
//                    System.out.println("isMultiple " + isMultiple);
//                    Map<String, PaiementInfo> paiements = new HashMap<>();
//                    PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
//                    String reference = request.getParameter("referencePaiement");
//                    String modePaiement = request.getParameter("payment-method");
//                    String[] estEnGrosListe = new String[nbLine];
//                    System.out.println(" montant payerrrr +++++  " + request.getParameter("valeurEspece"));
//                    String strMontantDonne = request.getParameter("valeurEspece");
//                    String montantGeneral = request.getParameter("totalGeneralInput");
//                    double montantPaye;
//                    if(strMontantDonne != null && !strMontantDonne.isEmpty()){
//                        montantPaye = Double.parseDouble(strMontantDonne);
//                    }else {
//                        montantPaye = Double.parseDouble(montantGeneral);
//                    }
//                    int ajustement = 0 ;
//                    System.out.println("modepaiement " + modePaiement);
//                    for (int i = 0; i < nbLine; i++) {
//                        String estEnGros = request.getParameter("estEnGros_" + i);
//                        if (i == 0 && estEnGros == null) {
//                            estEnGrosListe = new String[nbLine-1];
//                            ajustement = -1;
//                            continue;
//                        }
//                        estEnGrosListe[i + ajustement] = estEnGros;
//                    }
//                    if(isMultiple) {
//                        String refMvola = request.getParameter("refMvola");
//                        String refOrange = request.getParameter("refOrange");
//                        String refAirtel = request.getParameter("refAirtel");
//                        String refCheque = request.getParameter("refCheque");
//                        String refVisa = request.getParameter("refVisa");
//
//                        String strMontantMvola = request.getParameter("montantMvola");
//                        double montantMvola = (strMontantMvola != null && !strMontantMvola.isEmpty())
//                                ? Double.valueOf(strMontantMvola)
//                                : 0;
//
//                        String strEspece = request.getParameter("valeurEspece");
//                        double valeurEspece = (strEspece != null && !strEspece.isEmpty())
//                                ? Double.valueOf(strEspece)
//                                : 0;
//
//                        String strMontantOrange = request.getParameter("montantOrange");
//                        double montantOrange = (strMontantOrange != null && !strMontantOrange.isEmpty())
//                                ? Double.valueOf(strMontantOrange)
//                                : 0;
//
//                        String strMontantAirtel = request.getParameter("montantAirtel");
//                        double montantAirtel = (strMontantAirtel != null && !strMontantAirtel.isEmpty())
//                                ? Double.valueOf(strMontantAirtel)
//                                : 0;
//
//                        String strMontantCheque = request.getParameter("montantCheque");
//                        double montantCheque = (strMontantCheque != null && !strMontantCheque.isEmpty())
//                                ? Double.valueOf(strMontantCheque)
//                                : 0;
//
//                        String strMontantVisa = request.getParameter("montantVisa");
//                        double montantVisa = (strMontantVisa != null && !strMontantVisa.isEmpty())
//                                ? Double.valueOf(strMontantVisa)
//                                : 0;
//
//                        if(valeurEspece > 0) {
//                            paiements.put("especes", new PaiementInfo("", valeurEspece));
//                        }
//                        if(refMvola != null && !refMvola.isEmpty() && montantMvola > 0) {
//                            paiements.put("mvola", new PaiementInfo(refMvola, montantMvola));
//                        }
//                        if(refOrange != null && !refOrange.isEmpty() && montantOrange > 0) {
//                            paiements.put("orange", new PaiementInfo(refOrange, montantOrange));
//                        }
//                        if(refAirtel != null && !refAirtel.isEmpty() && montantAirtel > 0) {
//                            paiements.put("airtel", new PaiementInfo(refAirtel, montantAirtel));
//                        }
//                        if(refCheque != null && !refCheque.isEmpty() && montantCheque > 0) {
//                            paiements.put("cheque", new PaiementInfo(refCheque, montantCheque));
//                        }
//                        if(refVisa != null && !refVisa.isEmpty() && montantVisa > 0) {
//                            paiements.put("virement", new PaiementInfo(refVisa, montantVisa));
//                        }
//                        montantPaye = 0;
//                        idmere = Vente.enregistrerViserLivrerEncaisserMultiple(u, p,nomtable,colonneMere,paiements,estEnGrosListe,aretourner, montantPaye);
//                        if (idmere != null) {
//                            declencherImpression = "true";
//                        }
//                    } else {
//                        idmere = Vente.enregistrerViserLivrerEncaisser(u,p,nomtable,colonneMere,modePaiement,reference, estEnGrosListe,aretourner, montantPaye);
//                        if (idmere != null) {
//                            declencherImpression = "true";
//                        }
//                    }

            %>
    <iframe id="printFrame" style="display: none"></iframe>
    <script language="JavaScript">
        if(sessionStorage) {
            sessionStorage.removeItem('cartStateBeforeSubmit');
        }

        function ouvrirPdf(id) {
            if (id && id !== "") {
                var url = "flux_pdf.jsp?idVente=" + id;
                // var urlPDF = "/aigledor/pages/flux_pdf.jsp?idVente=" ;
                const printFrame = document.getElementById("printFrame");

                printFrame.src = url;
                printFrame.onload = () => {
                    printFrame.contentWindow.focus();
                    printFrame.contentWindow.print();

                    setTimeout(function() {
                        document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");
                    }, 3000);
                };
                // window.open(url, '_blank');
            }
        }

        window.onload = function() {
            <% if ("true".equals(declencherImpression)) { %>
            ouvrirPdf('<%= idmere %>');
            <% } %>

            // On laisse un petit délai (500ms) pour que le popup soit géré avant la redirection

        };
    </script>
    <%
            return;
        }

    int type = Utilitaire.stringToInt(typeBoutton);
            if (acte != null && acte.compareToIgnoreCase("insertSansControle") == 0) {
                mere = (ClassMAPTable) (Class.forName(classe).newInstance());
                fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
                PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
                ClassMAPTable cmere = p.getObjectAvecValeur();
                ClassMAPTable[] cfille = p.getObjectFilleAvecValeurSansControle();
                for (int i = 0; i < cfille.length; i++) {
                    cfille[i].setNomTable(nomtable);
                }
                ClassMAPTable o = (ClassMAPTable) u.createObjectMultiple(cmere, colonneMere, cfille);
                temp = (Object) o;
                if (temp != null) {
                    val = temp.toString();
                    idmere = o.getTuppleID();
                }%>
            <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
            <%}

            if (acte != null && acte.compareToIgnoreCase("interview") == 0) {
                mere = (ClassMAPTable) (Class.forName(classe).newInstance());
                fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
                PageUpdateMultiple p = new PageUpdateMultiple(mere, fille, request, nbLine, tId);
                ClassMAPTable cmere = p.getObjectAvecValeur();
                ClassMAPTable[] cfille = p.getObjectFilleAvecValeurSansControle();
                for (int i = 0; i < cfille.length; i++) {
                    cfille[i].setNomTable(nomtable);
                }
                ((ClassEtat)cmere).setEtat(ConstanteEtat.getEtatInterviewe());
                ClassMAPTable o = (ClassMAPTable) u.updateObjectMultiple(cmere, colonneMere, cfille);
                temp = (Object) o;
                if (temp != null) {
                    val = temp.toString();
                    idmere = o.getTuppleID();
                }%>
            <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
            <% }

            if (acte != null && acte.compareToIgnoreCase("updateSansControle") == 0) {
                mere = (ClassMAPTable) (Class.forName(classe).newInstance());
                fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
                PageUpdateMultiple p = new PageUpdateMultiple(mere, fille, request, nbLine, tId);
                ClassMAPTable cmere = p.getObjectAvecValeur();
                ClassMAPTable[] cfille = p.getObjectFilleAvecValeurSansControle();
                for (int i = 0; i < cfille.length; i++) {
                    cfille[i].setNomTable(nomtable);
                }
                ClassMAPTable o = (ClassMAPTable) u.updateObjectMultiple(cmere, colonneMere, cfille);
                temp = (Object) o;
                if (temp != null) {
                    val = temp.toString();
                    idmere = o.getTuppleID();
                }%>
            <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
            <%}
            if (acte != null && acte.compareToIgnoreCase("insert") == 0) {
                mere = (ClassMAPTable) (Class.forName(classe).newInstance());
                fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
                PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
                ClassMAPTable cmere = p.getObjectAvecValeur();
                ClassMAPTable[] cfille = p.getObjectFilleAvecValeur();
                for (int i = 0; i < cfille.length; i++) {
                    cfille[i].setNomTable(nomtable);
                }
                ClassMAPTable o = (ClassMAPTable) u.createObjectMultiple(cmere, colonneMere, cfille);
                temp = (Object) o;
                if (temp != null) {
                    val = temp.toString();
                    idmere = o.getTuppleID();
                }%>
    <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
    <% }
        if (acte != null && acte.compareToIgnoreCase("insertFille") == 0) {

                mere = (ClassMAPTable) (Class.forName(classe).newInstance());
                fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
                PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
                ClassMAPTable[] cfille = p.getObjectFilleAvecValeur();
                for (int i = 0; i < cfille.length; i++) {
                    cfille[i].setNomTable(nomtable);
                }
                String idMere=request.getParameter("idMere");
                if(idMere==null||idMere.isEmpty()){
                    throw new Exception("Id mere not provided");
                }
                u.createObjectFilleMultiple(idMere, colonneMere, cfille);
        %>

    <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idMere%>");</script>
    <% }

        if (acte != null && acte.compareToIgnoreCase("updateInsert") == 0) {
            mere = (ClassMAPTable) (Class.forName(classe).newInstance());
            fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
            PageUpdateMultiple p = new PageUpdateMultiple(mere, fille, request, nbLine, tId);
            ClassMAPTable cmere = p.getObjectAvecValeur();
            ClassMAPTable[] cfille = p.getObjectFilleAvecValeur();
            for (int i = 0; i < cfille.length; i++) {
                cfille[i].setNomTable(nomtable);
            }

            ClassMAPTable o = (ClassMAPTable) u.updateObjectMultiple(cmere, colonneMere, cfille);

            if (request.getParameter("classe").equalsIgnoreCase("faturefournisseur.FactureFournisseur")) {
                //FactureFournisseur fc = (FactureFournisseur) cmere;
                //fc.updatePriceMvtStockFille(fc.getId(), String.valueOf(u.getUser().getRefuser()), null);
            }
            temp = (Object) o;
            if (temp != null) {
                val = temp.toString();
                idmere = o.getTuppleID();
            }%>

    <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
    <% }

        if(acte.equals("viserTraite")){
            Traite traite=new Traite();
            traite.avantVerser(tId, u.getUser().getTuppleID(), request.getParameter("idcaisse"),request.getParameter("date"), null);
        }
        if(acte.equals("viserTraiteSimple")){
            Traite traite=new Traite();
            Date daty = Utilitaire.stringDate(request.getParameter("daty"));
            traite.setDaty(daty);
            traite.setId(id);
            String[] value = {request.getParameter("idTraite")};
            traite.avantVerser(value, u.getUser().getTuppleID(), request.getParameter("idfinaledestination"), null);
        }

        if (acte.compareToIgnoreCase("updateMultiple") == 0) {
            System.out.println("miditra");
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            Page p = new Page(t, request, nombreLigne, tId);
            ClassMAPTable[] f = p.getObjectAvecValeurTableauUpdate();
            u.updateObjectMultiple(f);
%>
        <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
        <%}

        if (acte.compareToIgnoreCase("deleteFille") == 0) {
            mere = (ClassMAPTable) (Class.forName(classe).newInstance());
            fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
            PageUpdateMultiple p = new PageUpdateMultiple(mere, fille, request, nbLine, tId);
            ClassMAPTable cmere = p.getObjectAvecValeur();
            ClassMAPTable[] cfille = p.getObjectFilleAvecValeur();
            for (int i = 0; i < cfille.length; i++) {
                cfille[i].setNomTable(nomtable);
            }
            u.deleteObjectMultiple(cmere, cfille);

        }
        /**
         * ********************************************
         */

        /**
         * ********************************************
         */
        if (acte.compareToIgnoreCase("debaucher") == 0) {
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            t.setValChamp(t.getAttributIDName(), request.getParameter("idpers"));
            t.setNomTable(nomtable);
            ClassMAPTable o = (ClassMAPTable) u.createObject(t);
    %>
    <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
    <%
        }

        if (acte.compareToIgnoreCase("attacher") == 0) {
            System.out.println("--------------- BOUTON VALIDER");
            for (int i = 0; i < tId.length; i++) {
                System.out.println("--------------- " + tId[i]);
                t = (ClassMAPTable) (Class.forName(classe).newInstance());
                System.out.println("t--------------- " + t);
                System.out.println("nomtable--------------- " + nomtable);
                t.setValChamp(t.getAttributIDName(), tId[i]);
                t.setNomTable(nomtable);
                ClassMAPTable o = (ClassMAPTable) u.validerObject(t);
                System.out.println("VITA " + tId[i]);
            }
        }
        if (acte.compareToIgnoreCase("delete") == 0) {
            String error = ""; %>
    <%//if(request.getParameter("confirm") != null){
        try {
            //System.out.println("suppression : " + request.getParameter("confirm") + " nom table : " + nomtable);
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            t.setValChamp(t.getAttributIDName(), request.getParameter("id"));
            if (nomtable != null && !nomtable.isEmpty()) {
                t.setNomTable(nomtable);
            }
            u.deleteObject(t);
        } catch (Exception e) {
            String errorMsg = e.getMessage() != null ? e.getMessage() : "Une erreur est survenue";
            errorMsg = errorMsg.replace("\\", "\\\\")
                               .replace("\"", "\\\"")
                               .replace("\r", "")
                               .replace("\n", "\\n");
        %>
    <script language="JavaScript">alert("<%=errorMsg%>");
        history.back();</script>
        <%
            }
            //                }else{%>
    <!--<script language="JavaScript">
//                    if (confirm("Voulez-vous vraiment supprimer ?")) { // Clic sur OK
//                        var url = window.location.href;
//                        url = url+"&confirm=oui";
//                        window.location.replace(url);
//                        //alert("url : "+url);
//                    } else{
//                        var url = document.referrer;
//                        window.location.replace(url);
//                    }
    </script>-->
    <%//  }
        }
        if (acte.compareToIgnoreCase("insertTypeObjet") == 0) {
            String[] vals = null;
            String[] desce = null;
            String nomTable = request.getParameter("nomtable");
            String nomProcedure = request.getParameter("procedure");
            String startProcedure = request.getParameter("prefixe");
            if (request.getParameter("nbrLigne") != null) {
                int taille = Utilitaire.stringToInt(request.getParameter("nbrLigne"));
                vals = new String[taille];
                desce = new String[taille];
                for (int i = 0; i < taille; i++) {
                    vals[i] = request.getParameter("val_" + (i + 1));
                    desce[i] = request.getParameter("desce_" + (i + 1));
                }
            }
            u.createTypeObjetMultiple(nomTable, nomProcedure, startProcedure, vals, desce);
        }
        if(acte.compareToIgnoreCase("insertMereLierFille")==0){
			String error = "";
			try {


				String[] liste_id_fille = request.getParameterValues("id");

				String colonneFille =request.getParameter("colonneFille");
				String classFille = request.getParameter("classeFille");
				fille= (ClassFille) (Class.forName(classFille).newInstance());
				t = (ClassMAPTable) (Class.forName(classe).newInstance());
				PageInsert pageInsert = new PageInsert(t, request);
				 mere= pageInsert.getObjectAvecValeur();
				u.insertMereLierFilles( (ClassMere)mere , (ClassFille) fille , liste_id_fille ,  colonneFille,  colonneMere );
			} catch (Exception e) {
				e.printStackTrace();
				out.println("<script language=\"JavaScript\">alert(\"Erreur durant la validation\")</script>");
			}
		}
        if (acte.compareToIgnoreCase("update") == 0) {
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            Page p = new Page(t, request);
            ClassMAPTable f = p.getObjectAvecValeur();
            temp = f;
            if (nomtable != null) {
                f.setNomTable(nomtable);
            }

            u.updateObject(f);
        }
        if (acte.compareToIgnoreCase("dupliquer") == 0) {
            String classeFille = request.getParameter("nomClasseFille");
            String nomColonneMere = request.getParameter("nomColonneMere");
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            t.setValChamp(t.getAttributIDName(), request.getParameter("id"));
            Object o = u.dupliquerObject(t, classeFille, nomColonneMere);
            val = o.toString();
    %>
    <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=val%>");</script>
    <%
        }
        if (acte.compareToIgnoreCase("annuler") == 0) {
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            t.setValChamp(t.getAttributIDName(), request.getParameter("id"));
            u.annulerObject(t);
        }

        if (acte.compareToIgnoreCase("annulerVisa") == 0) {
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            t.setValChamp(t.getAttributIDName(), request.getParameter("id"));
            temp = t;
            u.annulerVisa(t);
        }
        if (acte.compareToIgnoreCase("finaliser") == 0) {
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            t.setValChamp(t.getAttributIDName(), request.getParameter("id"));
            temp = t;
            u.finaliser(t);
        }
        if(acte.compareToIgnoreCase("validerTous")==0){
                ClassEtat objet = (ClassEtat)(Class.forName(classe).newInstance());
                objet.setNomTable(nomtable);
                u.validerObjectTous(objet);
        }
        if (acte.compareToIgnoreCase("valider") == 0) {
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            t.setValChamp(t.getAttributIDName(), request.getParameter("id"));
            ClassMAPTable o = (ClassMAPTable) u.validerObject(t);
            temp = t;
            val = o.getTuppleID();

    %>
    <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute + rajoutLie%>&id=<%=val%>");</script>
    <%
        }
        if (acte.compareToIgnoreCase("validerMultiple") == 0) {
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            ClassEtat[] objs=new ClassEtat[tId.length];
            for (int i = 0; i < tId.length; i++) {
                objs[i]= (ClassEtat) Class.forName(classe).newInstance();
                objs[i].setValChamp(t.getAttributIDName(), tId[i]);
            }
            u.validerObjectMultiple(objs);
    %>
    <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute + rajoutLie%>&id=<%=val%>");</script>
    <%
        }
        if (acte.compareToIgnoreCase("rejeter") == 0) {
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            PageInsert p = new PageInsert(t, request);
            ClassMAPTable f = p.getObjectAvecValeur();
            t.setNomTable(nomtable);
            t.setValChamp(t.getAttributIDName(), request.getParameter("id"));
            //u.rejeterObject(t);
        }
        if (acte.compareToIgnoreCase("cloturer") == 0) {
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            t.setValChamp(t.getAttributIDName(), request.getParameter("id"));
            u.cloturerObject(t);
        }

        if (rajoutLien != null) {

            for (int o = 0; o < rajoutLien.length; o++) {
                String valeur = request.getParameter(rajoutLien[o]);
                rajoutLie = rajoutLie + "&" + rajoutLien[o] + "=" + valeur;

            }

        }
    %>
    <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute + rajoutLie%>&valeur=<%=val%>&id=<%=id%>");</script>
    <%

    } catch (Exception ex) {
        ex.printStackTrace();
        String errorMsg = ex.getMessage() != null ? ex.getMessage() : "Une erreur est survenue";
        errorMsg = errorMsg.replace("\\", "\\\\")
                           .replace("\"", "\\\"")
                           .replace("\r", "")
                           .replace("\n", "\\n");
    %>
    <script type="text/javascript">alert("<%=errorMsg%>"); history.back();</script>
    <%
            return;
        }%>
</html>



