<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, mg.vola.models.*, mg.vola.dao.*" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>M-Vola | Transactions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', sans-serif; }
        .card-vola { border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.08); }
        .summary-card { background: #fffdf2; border: 1px solid #ffeeba; border-radius: 12px; }
        .nav-pills .nav-link { color: #666; border-radius: 10px; margin: 0 5px; transition: 0.3s; font-weight: bold; }
        .nav-pills .nav-link.active { background-color: #ffcc00; color: #000; box-shadow: 0 4px 10px rgba(255, 204, 0, 0.3); }
        .table-responsive { max-height: 500px; overflow-y: auto; }
        .toast-container { z-index: 3000; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="text-center mb-5">
        <h2 class="fw-bold text-uppercase">🏦 Gestion des Transactions</h2>
        <div class="mx-auto bg-warning mb-3" style="height: 4px; width: 60px; border-radius: 2px;"></div>
        
        <button class="btn btn-outline-primary btn-sm rounded-pill fw-bold px-4" data-bs-toggle="modal" data-bs-target="#releveModal">
            📄 GÉNÉRER UN RELEVÉ PDF
        </button>
    </div>

    <ul class="nav nav-pills nav-justified mb-4 mx-auto" style="max-width: 600px;" id="pills-tab" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" id="tab-envoi" data-bs-toggle="pill" data-bs-target="#content-envoi" type="button">📤 ENVOIS</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="tab-retrait" data-bs-toggle="pill" data-bs-target="#content-retrait" type="button">📥 RETRAITS</button>
        </li>
    </ul>

    <div class="tab-content">
        <div class="tab-pane fade show active" id="content-envoi">
            <div class="row g-4">
                <div class="col-md-5">
                    <div class="card card-vola p-4">
                        <h5 class="fw-bold mb-4 text-warning">Nouveau Transfert</h5>
                        <form action="TransactionServlet" method="POST" id="envoiForm">
                            <input type="hidden" name="action" value="envoyer">
                            <div class="mb-3">
                                <label class="form-label small fw-bold">NUMÉRO ENVOYEUR</label>
                                <input list="listeNumeros" name="numEnvoyeur" id="numE" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">NUMÉRO RÉCEPTEUR</label>
                                <input list="listeNumeros" name="numRecepteur" id="numR" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">MONTANT (Ar)</label>
                                <input type="number" name="montant" id="montantE" class="form-control form-control-lg fw-bold text-primary" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">RAISON</label>
                                <input type="text" name="raison" id="raisonE" class="form-control">
                            </div>
                            <div class="form-check form-switch mb-4">
                                <input class="form-check-input" type="checkbox" name="payerFraisRetrait" id="switchFrais">
                                <label class="form-check-label small fw-bold" for="switchFrais">L'envoyeur paie les frais de retrait</label>
                            </div>
                            <button type="button" onclick="preparerConfirmation('envoi')" class="btn btn-warning w-100 fw-bold py-3 rounded-pill shadow-sm">VALIDER L'ENVOI 🚀</button>
                        </form>
                    </div>
                </div>
                <div class="col-md-7">
                    <div class="card card-vola p-4">
                        <div class="d-flex justify-content-between mb-3">
                            <h5 class="fw-bold small text-uppercase">Historique des Envois</h5>
                            <input type="date" id="dateEnv" class="form-control form-control-sm w-auto" onchange="filtrer('env')">
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light small">
                                    <tr>
                                        <th>Date</th>
                                        <th>De ➔ À</th>
                                        <th>Montant</th>
                                        <th>Frais R. ?</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        TransactionDAO dao = new TransactionDAO();
                                        List<Envoi> listeE = dao.listerDerniersEnvois();
                                        for(Envoi e : listeE) {
                                    %>
                                    <tr class="row-env" data-date="<%= e.getDate().toString().substring(0,10) %>">
                                        <td class="small text-muted"><%= new java.text.SimpleDateFormat("dd/MM").format(e.getDate()) %></td>
                                        <td class="small"><b><%= e.getNumEnvoyeur() %></b> ➔ <%= e.getNumRecepteur() %></td>
                                        <td class="fw-bold"><%= String.format("%, d", e.getMontant()) %> Ar</td>
                                        <td><%= e.isPayer_frais_retrait() ? "✅" : "❌" %></td>
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
                <div class="col-md-5">
                    <div class="card card-vola p-4">
                        <h5 class="fw-bold mb-4 text-dark">Nouveau Retrait</h5>
                        <form action="TransactionServlet" method="POST" id="retraitForm">
                            <input type="hidden" name="action" value="retirer">
                            <div class="mb-3">
                                <label class="form-label small fw-bold">NUMÉRO DU CLIENT</label>
                                <input list="listeNumeros" name="numtel" id="numRet" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">MONTANT À RETIRER (Ar)</label>
                                <input type="number" name="montant" id="montantRet" class="form-control form-control-lg fw-bold" required>
                            </div>
                            <button type="button" onclick="preparerConfirmation('retrait')" class="btn btn-dark w-100 fw-bold py-3 rounded-pill">EFFECTUER LE RETRAIT 💵</button>
                        </form>
                    </div>
                </div>
                <div class="col-md-7">
                    <div class="card card-vola p-4">
                        <div class="d-flex justify-content-between mb-3">
                            <h5 class="fw-bold small text-uppercase">Historique des Retraits</h5>
                            <input type="date" id="dateRet" class="form-control form-control-sm w-auto" onchange="filtrer('ret')">
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light small">
                                    <tr>
                                        <th>Date</th>
                                        <th>Numéro</th>
                                        <th>Montant</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        List<Retrait> listeR = dao.listerDerniersRetraits();
                                        for(Retrait r : listeR) {
                                    %>
                                    <tr class="row-ret" data-date="<%= r.getDaterecep().toString().substring(0,10) %>">
                                        <td class="small text-muted"><%= new java.text.SimpleDateFormat("dd/MM").format(r.getDaterecep()) %></td>
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
        <div class="modal-content border-0 shadow" style="border-radius: 20px;">
            <div class="modal-header bg-primary text-white border-0 p-4" style="border-radius: 20px 20px 0 0;">
                <h5 class="modal-title fw-bold">Générer un relevé d'opération</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="RelevePdfServlet" method="GET" target="_blank">
                <div class="modal-body p-4">
                    <label class="form-label small fw-bold">SÉLECTIONNEZ LE NUMÉRO DU CLIENT</label>
                    <select name="numtel" class="form-select form-select-lg mb-3" required>
                        <option value="" selected disabled>Choisir un numéro...</option>
                        <% 
                           try { 
                               ClientDAO clDao = new ClientDAO(); 
                               for(Client cl : clDao.listerClients("")) { 
                        %>
                            <option value="<%= cl.getNumtel() %>"><%= cl.getNumtel() %> - <%= cl.getNom() %></option>
                        <% 
                               } 
                           } catch(Exception e) {} 
                        %>
                    </select>
                    <div class="alert alert-info small">
                        Le PDF contiendra l'historique complet (Envois, Réceptions et Retraits).
                    </div>
                </div>
                <div class="modal-footer border-0 p-3">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">TÉLÉCHARGER LE PDF 📥</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="confirmModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow" style="border-radius: 20px;">
            <div id="modalHeader" class="modal-header border-0 p-4" style="border-radius: 20px 20px 0 0;">
                <h5 class="modal-title fw-bold" id="modalTitle">Confirmation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <div id="confirmNum" class="fw-bold fs-3 text-primary mb-3"></div>
                <div class="summary-card p-3">
                    <div class="d-flex justify-content-between mb-2"><span>Montant :</span><span id="cMontant" class="fw-bold"></span></div>
                    <div id="rowFraisEnv" class="d-flex justify-content-between text-danger mb-1 small"><span>Frais d'envoi :</span><span id="cFraisE" class="fw-bold"></span></div>
                    <div id="rowFraisRet" class="d-flex justify-content-between text-danger mb-2 small"><span>Frais de retrait :</span><span id="cFraisR" class="fw-bold"></span></div>
                    <hr>
                    <div class="d-flex justify-content-between fs-5 fw-bold text-dark"><span>TOTAL :</span><span id="cTotal"></span></div>
                </div>
            </div>
            <div class="modal-footer border-0 p-3">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Annuler</button>
                <button type="button" id="btnFinal" class="btn btn-warning rounded-pill px-4 fw-bold">Confirmer</button>
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
        toastEl.className = "toast align-items-center text-white border-0 shadow-lg bg-" + type;
        toastBootstrap.show();
    }

    function preparerConfirmation(type) {
        let num, montant, retraitParam, actionForm;
        if(type === 'envoi') {
            num = document.getElementById('numR').value;
            montant = document.getElementById('montantE').value;
            retraitParam = document.getElementById('switchFrais').checked;
            actionForm = 'envoiForm';
            document.getElementById('modalHeader').className = "modal-header bg-warning border-0 p-4";
        } else {
            num = document.getElementById('numRet').value;
            montant = document.getElementById('montantRet').value;
            retraitParam = true;
            actionForm = 'retraitForm';
            document.getElementById('modalHeader').className = "modal-header bg-dark text-white border-0 p-4";
        }

        if(!num || !montant) {
            showNotify("Veuillez remplir les champs !", "danger");
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
        if(params.get('msg') === 'success') showNotify("✅ Opération effectuée !", "success");
        if(params.get('msg') === 'error_solde') showNotify("❌ Solde insuffisant !", "danger");
        if(params.get('msg') === 'error') showNotify("❌ Une erreur est survenue.", "danger");
        window.history.replaceState({}, '', window.location.pathname);
    }
</script>
</body>
</html>