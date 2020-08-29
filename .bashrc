#-------------------------------
# SSH Private Keys for GitHub 
#-------------------------------

# add each aditional key by increasing the array by one. 
KEY[1]="id_rsa_account-1"
KEY[2]="id_rsa_account-2"

#-------------------------------
# Start SSH Key Agent for GitHub 
#-------------------------------

SSH_ENV="$HOME/.ssh/environment"

function run_ssh_env {
  . "${SSH_ENV}" > /dev/null
}

function start_ssh_agent {
  echo "Initializing new SSH agent..."
  ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo "succeeded"
  chmod 600 "${SSH_ENV}"

  run_ssh_env;

  for i in "${KEY[@]}"
  do
    echo "adding SSH key ~/.ssh/$i;"
    ssh-add ~/.ssh/$i;
  done
}

if [ -f "${SSH_ENV}" ]; then
  run_ssh_env;
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_ssh_agent;
  }
else
  start_ssh_agent;
fi
