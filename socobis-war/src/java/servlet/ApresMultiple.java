package servlet;

import affichage.PageInsert;
import bean.ClassMAPTable;
import com.google.gson.Gson;
import prevision.Prevision;
import produits.Recette;
import user.UserEJB;
import utilitaire.Utilitaire;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/ApresMultiple")
@MultipartConfig

public class ApresMultiple extends HttpServlet {
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String bute;
    String nomtable = null;
    String typeBoutton;
    String champReturn;
    String action = null;
    private static final Gson gson = new Gson();
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        Map<String, Object> res = new HashMap<>();
        try {
            nomtable = request.getParameter("nomtable");
            typeBoutton = request.getParameter("type");
            lien = (String) session.getValue("lien");
            u = (UserEJB) session.getAttribute("u");
            acte = request.getParameter("acte");
            bute = request.getParameter("bute");
            action = request.getParameter("action");
            Object temp = null;
            String[] rajoutLien = null;
            String classe = request.getParameter("classe");
            String[] id = request.getParameterValues("ids");
            System.out.println("ATY ANATY SERVLET "+id[0]);
            ClassMAPTable t = null;
            String tempRajout = request.getParameter("rajoutLien");
            String val = "";

            champReturn = request.getParameter("champReturn");
            String rajoutLie = "";
            if (tempRajout != null && tempRajout.compareToIgnoreCase("") != 0) {
                rajoutLien = Utilitaire.split(tempRajout, "-");
            }
            String tempRajoutLienFormu = request.getParameter("rajoutLienFormu");
            String rajoutLieFormu = "";
            String[] rajoutLienFormu = null;
            if (tempRajoutLienFormu != null && tempRajoutLienFormu.compareToIgnoreCase("") != 0) {
                rajoutLienFormu = Utilitaire.split(tempRajoutLienFormu, "-");
                if(rajoutLienFormu.length == 2){
                    rajoutLieFormu = "&"+rajoutLienFormu[0]+"="+rajoutLienFormu[1];
                }
            }
            String acteDetail=request.getParameter("acteDetail");

            if (typeBoutton == null || typeBoutton.compareToIgnoreCase("") == 0) {
                typeBoutton = "3"; //par defaut modifier
            }

            if (rajoutLien != null) {

                for (int o = 0; o < rajoutLien.length; o++) {
                    String valeur = request.getParameter(rajoutLien[o]);
                    rajoutLie = rajoutLie + "&" + rajoutLien[o] + "=" + valeur;

                }

            }

            if(acte != null && !"".equals(acte) && acte.equals("modifier_recette")){
                Recette rec=new Recette();
                rec.modifQte(String.valueOf(u.getUser().getRefuser()),id,request.getParameterValues("quantite") ,null);
                res.put("status", "success");
                res.put("butApres", lien+"?but="+bute+rajoutLie);
            }
            if(acte != null && !"".equals(acte) && acte.equals("supprimer_recette")){
                Recette rec=new Recette();
//          if (!u.getUser().getLoginuser().equalsIgnoreCase("narindra") && !u.getUser().getLoginuser().equalsIgnoreCase("Baovola"))
//            {
//                 throw new Exception ("Modification non autoris\\351");
//            }
                rec.suppressionMultiple(id,""+u.getUser().getRefuser() , null);
                res.put("status", "success");
                res.put("butApres", lien+"?but="+bute+rajoutLie);
            }


            out.print(gson.toJson(res));
            out.flush();
        } catch (Exception e) {
            res.put("status", "error");
            res.put("message", e.getMessage());
            out.print(gson.toJson(res));
            out.flush();
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        Map<String, Object> res = new HashMap<>();
        try {
            nomtable = request.getParameter("nomtable");
            typeBoutton = request.getParameter("type");
            lien = (String) session.getValue("lien");
            u = (UserEJB) session.getAttribute("u");
            acte = request.getParameter("acte");
            bute = request.getParameter("bute");
            action = request.getParameter("action");
            Object temp = null;
            String[] rajoutLien = null;
            String classe = request.getParameter("classe");
            String[] id = request.getParameterValues("ids");
            System.out.println("ATY ANATY SERVLET "+acte+" bute = "+bute+" iddd = ");
            ClassMAPTable t = null;
            String tempRajout = request.getParameter("rajoutLien");
            String val = "";

            champReturn = request.getParameter("champReturn");
            String rajoutLie = "";
            if (tempRajout != null && tempRajout.compareToIgnoreCase("") != 0) {
                rajoutLien = Utilitaire.split(tempRajout, "-");
            }
            String tempRajoutLienFormu = request.getParameter("rajoutLienFormu");
            String rajoutLieFormu = "";
            String[] rajoutLienFormu = null;
            if (tempRajoutLienFormu != null && tempRajoutLienFormu.compareToIgnoreCase("") != 0) {
                rajoutLienFormu = Utilitaire.split(tempRajoutLienFormu, "-");
                if(rajoutLienFormu.length == 2){
                    rajoutLieFormu = "&"+rajoutLienFormu[0]+"="+rajoutLienFormu[1];
                }
            }
            String acteDetail=request.getParameter("acteDetail");

            if (typeBoutton == null || typeBoutton.compareToIgnoreCase("") == 0) {
                typeBoutton = "3"; //par defaut modifier
            }

            if (rajoutLien != null) {

                for (int o = 0; o < rajoutLien.length; o++) {
                    String valeur = request.getParameter(rajoutLien[o]);
                    rajoutLie = rajoutLie + "&" + rajoutLien[o] + "=" + valeur;

                }

            }

            if(acte != null && !"".equals(acte) && acte.equals("modifier_recette")){
                Recette rec=new Recette();
                rec.modifQte(String.valueOf(u.getUser().getRefuser()),id,request.getParameterValues("quantite") ,null);
                lien=lien.replace("module.jsp","moduleLeger.jsp");
                res.put("status", "success");
                res.put("butApres", lien+"?but="+bute+rajoutLie);
            }
            if(acte != null && !"".equals(acte) && acte.equals("supprimer_recette")){
                Recette rec=new Recette();
//          if (!u.getUser().getLoginuser().equalsIgnoreCase("narindra") && !u.getUser().getLoginuser().equalsIgnoreCase("Baovola"))
//            {
//                 throw new Exception ("Modification non autoris\\351");
//            }
                rec.suppressionMultiple(id,""+u.getUser().getRefuser() , null);
                lien=lien.replace("module.jsp","moduleLeger.jsp");
                res.put("status", "success");
                res.put("butApres", lien+"?but="+bute+rajoutLie);
            }

            if(acte != null && !"".equals(acte) && acte.equals("modifier_prevision")){
                Prevision rec=new Prevision();
                rec.modifierPP(String.valueOf(u.getUser().getRefuser()),id,request.getParameterValues("debit"), request.getParameterValues("credit"), request.getParameterValues("taux"), request.getParameterValues("daty"),null);
                lien=lien.replace("module.jsp","moduleLeger.jsp");
                res.put("status", "success");
                res.put("butApres", lien+"?but="+bute+rajoutLie);
            }
            if(acte != null && !"".equals(acte) && acte.equals("supprimer_prevision")){
                Prevision rec=new Prevision();
                rec.suppressionMultiple(id,""+u.getUser().getRefuser() , null);
                lien=lien.replace("module.jsp","moduleLeger.jsp");
                res.put("status", "success");
                res.put("butApres", lien+"?but="+bute+rajoutLie);
            }
            if(acte != null && !"".equals(acte) && acte.equals("scinder_prevision")){
                Prevision rec=new Prevision();
                rec.scinder (id,""+u.getUser().getRefuser() , null);
                lien=lien.replace("module.jsp","moduleLeger.jsp");
                res.put("status", "success");
                res.put("butApres", lien+"?but="+bute+rajoutLie);
            }


            out.print(gson.toJson(res));
            out.flush();
        } catch (Exception e) {
            res.put("status", "error");
            res.put("message", e.getMessage());
            out.print(gson.toJson(res));
            out.flush();
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }

}
