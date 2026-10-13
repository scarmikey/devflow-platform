def call() {
    stage('Create Python Virtual Environment') {
        sh 'python3 -m venv .venv'
    }

    stage('Install Dependencies') {
        sh '.venv/bin/python -m pip install -r requirements.txt'
    }

    stage('Run Tests') {
        sh '.venv/bin/python -m pytest -q'
    }
}
