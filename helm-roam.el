;;; helm-roam.el --- Helm command for org-roam -*- lexical-binding: t -*-

;; Author: VHQR <zq_cmd@163.com>
;; Version: 1.0.2
;; Package-Requires: ((emacs "24.1") (org "9.3") (helm "3.9.9") (org-roam "2.2.2"))
;; Keywords: org-mode, roam, helm, convenience
;; URL: https://github.com/vhqr0/helm-roam

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:
;; Helm command for org-roam, list roam nodes, find node, insert link
;; to node, and capture to an exist or new node.  M-x helm-roam.

;;; Code:

(require 'helm)
(require 'org-roam)

(defun helm-roam-action-find (node)
  "Find NODE in same window."
  (org-roam-node-visit node))

(defun helm-roam-action-find-other-window (node)
  "Find NODE in other window."
  (org-roam-node-visit node t))

(defun helm-roam-action-insert (node)
  "Insert link to NODE."
  (insert (org-link-make-string
           (concat "id:" (org-roam-node-id node))
           (org-roam-node-formatted node))))

(defun helm-roam-action-capture (node)
  "Capture to an exist NODE."
  (org-roam-capture- :node node))

(defun helm-roam-dummy-action-create (title)
  "Capture to a new node with TITLE."
  (org-roam-capture- :node (org-roam-node-create :title title)))

(defvar helm-roam-actions
  (helm-make-actions
   "Find Node" #'helm-roam-action-find
   "Find Node Other Window" #'helm-roam-action-find-other-window
   "Insert Node" #'helm-roam-action-insert
   "Capture Node" #'helm-roam-action-capture))

(defvar helm-roam-dummy-actions
  (helm-make-actions
   "Create Node" #'helm-roam-dummy-action-create))

(defvar helm-roam-source
  (helm-build-sync-source "Roam Nodes"
    :candidates 'org-roam-node-read--completions
    :action helm-roam-actions
    :persistent-action #'helm-roam-action-find))

(defvar helm-roam-dummy-source
  (helm-build-dummy-source "Roam Create Node"
    :action helm-roam-dummy-actions))

;;;###autoload
(defun helm-roam ()
  "Helm command for `org-roam'."
  (interactive)
  (helm :sources '(helm-roam-source helm-roam-dummy-source)
        :buffer "*helm roam*"))

(provide 'helm-roam)
;;; helm-roam.el ends here
