<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, mg.vola.models.*, mg.vola.dao.*" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCash | Transactions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --main-dark: #0F172A;
            --accent-mint: #2DD4BF;
            --bg-page: #F1F5F9;
        }

        body { 
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-page); 
            color: var(--main-dark);
        }

        /* --- ELEMENTS DE DESIGN --- */
        .header-section { 
            background: white; 
            border-left: 5px solid var(--accent-mint);
            border-radius: 15px;
        }

        .card-vola { 
            border: none; 
            border-radius: 20px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.05); 
            background: white;
        }

        /* Onglets / Tabs */
        .nav-pills .nav-link {
            color: var(--main-dark) !important;
            border-radius: 50px;
            padding: 10px 25px;
            font-weight: 600;
            transition: 0.3s;
        }
        .nav-pills .nav-link.active {
            background-color: var(--main-dark) !important;
            color: var(--accent-mint) !important;
        }

        /* Style Tableaux amélioré */
        .table thead { background-color: var(--main-dark); color: white; }
        .table thead th { border: none; padding: 15px; font-size: 0.8rem; text-transform: uppercase; }
        .table-responsive { max-height: 450px; overflow-y: auto; border-radius: 10px; }
        
        .row-env, .row-ret { transition: all 0.2s; border-left: 3px solid transparent; }
        .row-env:hover, .row-ret:hover { background-color: #f8fafc; border-left: 3px solid var(--accent-mint); }

        .btn-mint { background-color: var(--accent-mint); color: var(--main-dark); font-weight: 600; border: none; }
        .btn-dark-nova { background-color: var(--main-dark); color: white; border: none; }
        
        .summary-card { background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 12px; }
        .price-text { color: #0d9488; font-weight: 700; }
        .badge-id { background: #e2e8f0; color: var(--main-dark); font-weight: 700; }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container py-5">
    
    <div class="header-section shadow-sm p-4 mb-5 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">Gestion des Flux</h2>
            <p class="mb-0 text-muted">Enregistrement des envois et retraits d'argent</p>
        </div>
        <button class="btn btn-dark-nova rounded-pill px-4 py-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#releveModal">
            <i class="bi bi-file-earmark-pdf"></i> Générer Relevé PDF
        </button>
    </div>

    <ul class="nav nav-pills mb-4 justify-content-center" id="pills-tab" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#content-envoi">Transferts (Envoi)</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="pill" data-bs-target="#content-retrait">Retraits (Client)</button>
        </li>
    </ul>

    <div class="tab-content mt-4">
        <div class="tab-pane fade show active" id="content-envoi">
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="card card-vola p-4">
                        <h5 class="fw-bold mb-4">Nouveau Transfert</h5>
                        <form action="TransactionServlet" method="POST" id="envoiForm">
                            <input type="hidden" name="action" value="envoyer">
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Numéro Envoyeur</label>
                                <input list="listeNumeros" name="numEnvoyeur" class="form-control rounded-pill" placeholder="034..." required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Numéro Récepteur</label>
                                <input list="listeNumeros" name="numRecepteur" class="form-control rounded-pill" placeholder="032..." required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Montant (Ar)</label>
                                <input type="number" name="montant" id="montantE" class="form-control form-control-lg fw-bold text-success rounded-pill" min="1" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Motif / Raison</label>
                                <input type="text" name="raison" class="form-control rounded-pill" placeholder="Ex: Cadeau, Loyer...">
                            </div>
                            <div class="form-check form-switch mb-4">
                                <input class="form-check-input" type="checkbox" name="payerFraisRetrait" id="switchFrais">
                                <label class="form-check-label small fw-bold" for="switchFrais">Inclure frais de retrait</label>
                            </div>
                            <button type="button" onclick="preparerConfirmation('envoi')" class="btn btn-mint w-100 fw-bold py-3 rounded-pill shadow-sm">Valider l'envoi</button>
                        </form>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="card card-vola p-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="fw-bold text-uppercase m-0">Historique des envois</h6>
                            <input type="date" id="dateEnv" class="form-control form-control-sm w-auto rounded-pill" onchange="filtrer('env')">
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>De ➔ Vers</th>
                                        <th>Raison</th>
                                        <th>Montant</th>
                                        <th class="text-center">Frais R.</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        TransactionDAO dao = new TransactionDAO();
                                        List<Envoi> listeE = dao.listerDerniersEnvois();
                                        for(Envoi e : listeE) {
                                    %>
                                    <tr class="row-env" data-date="<%= e.getDate().toString().substring(0,10) %>">
                                        <td class="small text-muted"><%= new java.text.SimpleDateFormat("dd/MM/yy").format(e.getDate()) %></td>
                                        <td><span class="fw-bold"><%= e.getNumEnvoyeur() %></span> ➔ <%= e.getNumRecepteur() %></td>
                                        <td class="small text-muted text-truncate" style="max-width: 150px;"><%= (e.getRaison() != null && !e.getRaison().isEmpty()) ? e.getRaison() : "-" %></td>
                                        <td class="price-text"><%= String.format("%, d", e.getMontant()) %> Ar</td>
                                        <td class="text-center"><%= e.isPayer_frais_retrait() ? "✅" : "❌" %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="tab-pane fade" id="content-retrait">
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="card card-vola p-4">
                        <h5 class="fw-bold mb-4">Effectuer un Retrait</h5>
                        <form action="TransactionServlet" method="POST" id="retraitForm">
                            <input type="hidden" name="action" value="retirer">
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Numéro du Client</label>
                                <input list="listeNumeros" name="numtel" class="form-control rounded-pill" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Montant à retirer (Ar)</label>
                                <input type="number" name="montant" id="montantRet" class="form-control form-control-lg fw-bold rounded-pill" min="1" required>
                            </div>
                            <button type="button" onclick="preparerConfirmation('retrait')" class="btn btn-dark-nova w-100 fw-bold py-3 rounded-pill">Valider le retrait</button>
                        </form>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="card card-vola p-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="fw-bold text-uppercase m-0">Historique des retraits</h6>
                            <input type="date" id="dateRet" class="form-control form-control-sm w-auto rounded-pill" onchange="filtrer('ret')">
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Numéro</th>
                                        <th>Montant Retiré</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        List<Retrait> listeR = dao.listerDerniersRetraits();
                                        for(Retrait r : listeR) {
                                    %>
                                    <tr class="row-ret" data-date="<%= r.getDaterecep().toString().substring(0,10) %>">
                                        <td class="small text-muted"><%= new java.text.SimpleDateFormat("dd/MM/yy").format(r.getDaterecep()) %></td>
                                        <td class="fw-bold"><%= r.getNumtel() %></td>
                                        <td class="text-danger fw-bold">- <%= String.format("%, d", r.getMontant()) %> Ar</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="releveModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
            <div class="modal-header bg-dark text-white border-0 p-4">
                <h5 class="modal-title fw-bold">Générer un relevé d'opération</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
           <form action="RelevePdfServlet" method="GET" target="_blank">
			    <div class="modal-body p-4">
			        <div class="mb-3">
			            <label class="form-label small fw-bold">Numéro du client</label>
			            <select name="numtel" class="form-select rounded-pill" required>
			                <option value="" selected disabled>Choisir un numéro...</option>
			                <% try { ClientDAO clDao = new ClientDAO(); for(Client cl : clDao.listerClients("")) { %>
			                    <option value="<%= cl.getNumtel() %>"><%= cl.getNumtel() %> - <%= cl.getNom() %></option>
			                <% } } catch(Exception e) {} %>
			            </select>
			        </div>
			        
			        <div class="mb-3">
			            <label class="form-label small fw-bold">Choisir le mois du relevé</label>
			            <input type="month" name="mois" class="form-control rounded-pill" required>
			        </div>
			
			        <div class="p-3 bg-light rounded-4 small text-muted">
			            Le document inclura les transactions pour le mois sélectionné.
			        </div>
			   
			    
                <div class="modal-footer border-0 p-3">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-mint rounded-pill px-4 shadow-sm">Télécharger PDF</button>
                </div>
               </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="confirmModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
            <div id="modalHeader" class="modal-header border-0 p-4">
                <h5 class="modal-title fw-bold">Confirmation Opération</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <div id="confirmNum" class="fw-bold fs-3 text-primary mb-3"></div>
                <div class="summary-card p-4">
                    <div class="d-flex justify-content-between mb-2"><span>Montant de base :</span><span id="cMontant" class="fw-bold"></span></div>
                    <div id="rowFraisEnv" class="d-flex justify-content-between text-danger mb-1 small"><span>Frais d'envoi :</span><span id="cFraisE" class="fw-bold"></span></div>
                    <div id="rowFraisRet" class="d-flex justify-content-between text-danger mb-2 small"><span>Frais de retrait :</span><span id="cFraisR" class="fw-bold"></span></div>
                    <hr>
                    <div class="d-flex justify-content-between fs-4 fw-bold text-dark"><span>TOTAL À DÉBITER :</span><span id="cTotal"></span></div>
                </div>
            </div>
            <div class="modal-footer border-0 p-4">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Annuler</button>
                <button type="button" id="btnFinal" class="btn btn-dark-nova rounded-pill px-4 shadow">Confirmer l'opération</button>
            </div>
        </div>
    </div>
</div>

<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="liveToast" class="toast align-items-center text-white border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body fw-bold" id="toastMsg"></div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<datalist id="listeNumeros">
    <% try { ClientDAO clDao = new ClientDAO(); for(Client cl : clDao.listerClients("")) { %>
        <option value="<%= cl.getNumtel() %>"><%= cl.getNom() %></option>
    <% } } catch(Exception e) {} %>
</datalist>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const bModal = new bootstrap.Modal(document.getElementById('confirmModal'));
    const toastBootstrap = bootstrap.Toast.getOrCreateInstance(document.getElementById('liveToast'));

    function showNotify(message, type) {
        const toastEl = document.getElementById('liveToast');
        document.getElementById('toastMsg').innerText = message;
        toastEl.className = "toast align-items-center text-white border-0 shadow-lg bg-" + (type === 'success' ? 'success' : 'danger');
        toastBootstrap.show();
    }

    function preparerConfirmation(type) {
        let num, montant, retraitParam, actionForm;
        if(type === 'envoi') {
            num = document.querySelector('input[name="numRecepteur"]').value;
            montant = document.getElementById('montantE').value;
            retraitParam = document.getElementById('switchFrais').checked;
            actionForm = 'envoiForm';
            document.getElementById('modalHeader').className = "modal-header bg-mint border-0 p-4";
        } else {
            num = document.querySelector('#content-retrait input[name="numtel"]').value;
            montant = document.getElementById('montantRet').value;
            retraitParam = true;
            actionForm = 'retraitForm';
            document.getElementById('modalHeader').className = "modal-header bg-dark text-white border-0 p-4";
        }

        if(!num || montant < 1) {
            showNotify("Veuillez saisir un numéro et un montant valide (min 1 Ar).", "error");
            return;
        }

        fetch("CalculFraisServlet?montant=" + montant + "&retrait=" + retraitParam)
            .then(r => r.text())
            .then(data => {
                const f = data.split(',');
                const fE = (type === 'envoi') ? parseInt(f[0]) : 0;
                const fR = parseInt(f[1]);
                const total = parseInt(montant) + fE + fR;

                document.getElementById('confirmNum').innerText = num;
                document.getElementById('cMontant').innerText = parseInt(montant).toLocaleString() + " Ar";
                document.getElementById('rowFraisEnv').style.display = (type === 'envoi') ? 'flex' : 'none';
                document.getElementById('cFraisE').innerText = "+ " + fE.toLocaleString() + " Ar";
                document.getElementById('cFraisR').innerText = "+ " + fR.toLocaleString() + " Ar";
                document.getElementById('cTotal').innerText = total.toLocaleString() + " Ar";

                document.getElementById('btnFinal').onclick = () => document.getElementById(actionForm).submit();
                bModal.show();
            });
    }

    function filtrer(type) {
        const d = (type === 'env') ? document.getElementById('dateEnv').value : document.getElementById('dateRet').value;
        const rows = (type === 'env') ? document.querySelectorAll('.row-env') : document.querySelectorAll('.row-ret');
        rows.forEach(r => r.style.display = (!d || r.dataset.date === d) ? "" : "none");
    }

    window.onload = () => {
        const params = new URLSearchParams(window.location.search);
        if(params.get('msg') === 'success') showNotify("Opération validée avec succès !", "success");
        if(params.get('msg') === 'error_solde') showNotify("Solde insuffisant pour cette opération.", "error");
        if(params.get('msg') === 'error') showNotify("Une erreur technique est survenue.", "error");
        window.history.replaceState({}, '', window.location.pathname);
    }
</script>
</body>
</html>