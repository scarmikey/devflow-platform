def call() {
    stage('Create Python Virtual Environment') {
        sh 'python3 -m venv .venv'
    }

    stage('Install Dependencies') {
        sh '.venv/bin/python -m pip install -r requirements-dev.txt'
    }

    stage('Lint') {
        sh '.venv/bin/ruff check app tests'
    }

    stage('Run Tests') {
        sh '.venv/bin/python -m pytest -q'
    }
}
