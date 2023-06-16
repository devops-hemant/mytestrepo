# mytestrepo

For the sake of this assignment I am fetching few details regading the PRs but this can be modified later as per the requirement. Also as this is just a demonstration that's why I am keeping the secrets in clear text only.

# To test the script at local system.
1) Pull the script to local.
2) Run the script like following

    ```receiver="recipient email address" repository="repository URL" ./script.sh```

    Example:

    ```receiver="devopshemant@gmail.com" repository="https://github.com/Azure/k8s-set-context" ./script.sh```

# To test the script with GitHub Actions.
1) Go to Actions tab.
2) Click on the PR_report_send workflow.
3) Click on "Run workflow" button.
4) Enter recipient email address and hit the "Run workflow" button.