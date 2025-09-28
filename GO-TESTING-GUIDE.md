# Go项目中使用 Specify-Unit 测试工具链指南

这个spec驱动的单元测试工具链完全支持Go项目！以下是在Go项目中使用的完整指南。

## 🚀 快速开始

### 1. Go项目结构示例

```
my-go-project/
├── go.mod
├── go.sum
├── cmd/
│   └── server/
│       └── main.go
├── internal/
│   ├── user/
│   │   ├── user.go
│   │   ├── user_test.go      # 单元测试
│   │   └── service.go
│   └── auth/
│       ├── auth.go
│       └── auth_test.go
├── pkg/
│   └── validator/
│       ├── validator.go
│       └── validator_test.go
├── testdata/                 # 测试数据
│   ├── users.json
│   └── config.yaml
├── mocks/                    # 生成的Mock
│   ├── mock_user_service.go
│   └── mock_database.go
└── tests/                    # Specify-unit 生成的规范
    └── 001-unit-test-user-validation/
        ├── test-spec.md
        ├── test-plan.md
        └── test-tasks.md
```

## 📋 完整工作流程示例

### 步骤1：创建测试规范

```bash
# 创建Go风格的测试规范
/specify-unit test Go user validation functions with email format checking and password strength validation
```

**生成的测试分支**: `001-unit-test-go-user-validation`

### 步骤2：制定测试计划

```bash
/plan-unit
```

**生成的测试计划示例**:

```markdown
# Unit Test Implementation Plan: Go User Validation Tests

## Test Technical Context
**Testing Framework**: Go testing package
**Primary Test Libraries**: testify/assert, testify/suite
**Assertion Library**: testify/assert
**Mock Framework**: gomock, testify/mock
**Test Runner**: go test
**Coverage Tool**: go test -cover -coverprofile=coverage.out
**CI Integration**: GitHub Actions with Go workflow
**Performance Goals**: <2s test suite, 85% coverage, <10ms per test
```

### 步骤3：分解测试任务

```bash
/tasks-unit
```

**生成的Go特定任务**:

```markdown
## Phase UT.1: Test Setup
- [ ] UT001 Initialize Go testing with go.mod configuration
- [ ] UT002 Install testify and gomock dependencies
- [ ] UT003 [P] Setup coverage reporting (go test -cover)
- [ ] UT004 [P] Configure GitHub Actions Go workflow

## Phase UT.2: Mock Implementation
- [ ] UT005 [P] Generate UserService mock with gomock
- [ ] UT006 [P] Generate Database interface mock
- [ ] UT007 [P] Create test data fixtures in testdata/

## Phase UT.3: Unit Tests
- [ ] UT008 [P] Test ValidateEmail() in user_test.go
- [ ] UT009 [P] Test ValidatePassword() in user_test.go
- [ ] UT010 [P] Test CreateUser() in service_test.go
```

### 步骤4：实施测试

```bash
/implement-unit
```

## 🔧 Go测试最佳实践集成

### 测试文件命名约定
- **单元测试**: `user_test.go` (与源文件同包)
- **集成测试**: `integration_test.go`
- **基准测试**: `user_bench_test.go`

### 测试函数命名
```go
// 好的测试函数名
func TestUser_ValidateEmail_ValidEmail_ReturnsTrue(t *testing.T)
func TestUser_ValidateEmail_InvalidFormat_ReturnsError(t *testing.T)
func TestUserService_CreateUser_DuplicateEmail_ReturnsConflictError(t *testing.T)
```

### Mock生成和使用

#### 1. 使用gomock
```bash
# 生成mock
go install github.com/golang/mock/mockgen@latest
mockgen -source=internal/user/service.go -destination=mocks/mock_user_service.go
```

#### 2. 使用testify/mock
```go
type MockUserService struct {
    mock.Mock
}

func (m *MockUserService) CreateUser(user *User) error {
    args := m.Called(user)
    return args.Error(0)
}
```

### 测试数据管理

#### testdata/ 目录结构
```
testdata/
├── valid_users.json
├── invalid_emails.json
├── test_config.yaml
└── fixtures/
    ├── user_valid.json
    └── user_invalid.json
```

#### 测试数据加载
```go
func loadTestData(t *testing.T, filename string) []byte {
    data, err := os.ReadFile(filepath.Join("testdata", filename))
    require.NoError(t, err)
    return data
}
```

## 🧪 Go特定测试模式

### 1. Table-Driven Tests (表驱动测试)

specify-unit工具会生成这样的测试结构：

```go
func TestUser_ValidateEmail(t *testing.T) {
    tests := []struct {
        name    string
        email   string
        want    bool
        wantErr bool
    }{
        {
            name:    "valid email",
            email:   "user@example.com",
            want:    true,
            wantErr: false,
        },
        {
            name:    "invalid format",
            email:   "invalid-email",
            want:    false,
            wantErr: true,
        },
        // More test cases...
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            u := &User{}
            got, err := u.ValidateEmail(tt.email)
            
            if tt.wantErr {
                assert.Error(t, err)
                return
            }
            
            assert.NoError(t, err)
            assert.Equal(t, tt.want, got)
        })
    }
}
```

### 2. Benchmark Tests (基准测试)

```go
func BenchmarkUser_ValidateEmail(b *testing.B) {
    u := &User{}
    email := "benchmark@example.com"
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _, _ = u.ValidateEmail(email)
    }
}
```

### 3. Test Suites with testify

```go
type UserTestSuite struct {
    suite.Suite
    user    *User
    mockDB  *MockDatabase
}

func (suite *UserTestSuite) SetupTest() {
    suite.user = &User{}
    suite.mockDB = &MockDatabase{}
}

func (suite *UserTestSuite) TestValidateEmail() {
    // Test implementation
}

func TestUserSuite(t *testing.T) {
    suite.Run(t, new(UserTestSuite))
}
```

## 📊 覆盖率和质量检查

### 覆盖率报告
```bash
# 生成覆盖率报告
go test -cover -coverprofile=coverage.out ./...

# 查看详细报告
go tool cover -html=coverage.out

# 按包查看覆盖率
go test -cover ./internal/user/
go test -cover ./pkg/validator/
```

### CI/CD 集成示例

**GitHub Actions 工作流** (`.github/workflows/test.yml`):

```yaml
name: Go Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Go
      uses: actions/setup-go@v3
      with:
        go-version: 1.21
        
    - name: Install dependencies
      run: |
        go mod download
        go install github.com/golang/mock/mockgen@latest
        
    - name: Generate mocks
      run: go generate ./...
      
    - name: Run tests
      run: |
        go test -race -coverprofile=coverage.out -covermode=atomic ./...
        
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.out
        
    - name: Check coverage threshold
      run: |
        COVERAGE=$(go tool cover -func=coverage.out | grep total | awk '{print substr($3, 1, length($3)-1)}')
        echo "Coverage: $COVERAGE%"
        if (( $(echo "$COVERAGE < 85" | bc -l) )); then
          echo "Coverage $COVERAGE% is below threshold 85%"
          exit 1
        fi
```

## 🎯 Go项目特有的测试策略

### 1. 接口测试
```go
// 测试接口实现
func TestUserService_ImplementsUserServiceInterface(t *testing.T) {
    var _ UserServiceInterface = (*UserService)(nil)
}
```

### 2. 并发安全测试
```go
func TestUserService_CreateUser_ConcurrentSafety(t *testing.T) {
    service := NewUserService()
    
    var wg sync.WaitGroup
    errors := make(chan error, 100)
    
    // 并发创建用户
    for i := 0; i < 100; i++ {
        wg.Add(1)
        go func(id int) {
            defer wg.Done()
            user := &User{
                Email: fmt.Sprintf("user%d@example.com", id),
            }
            if err := service.CreateUser(user); err != nil {
                errors <- err
            }
        }(i)
    }
    
    wg.Wait()
    close(errors)
    
    // 检查错误
    for err := range errors {
        t.Errorf("Concurrent operation failed: %v", err)
    }
}
```

### 3. 错误处理测试
```go
func TestUser_ValidateEmail_ReturnsExpectedErrors(t *testing.T) {
    tests := []struct {
        name      string
        email     string
        wantError error
    }{
        {
            name:      "empty email",
            email:     "",
            wantError: ErrEmptyEmail,
        },
        {
            name:      "invalid format",
            email:     "invalid",
            wantError: ErrInvalidEmailFormat,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            u := &User{}
            _, err := u.ValidateEmail(tt.email)
            assert.ErrorIs(t, err, tt.wantError)
        })
    }
}
```

## 📝 常用Go测试工具

### 核心工具
- **go test**: 标准测试运行器
- **testify**: 断言和测试套件
- **gomock**: Mock生成工具
- **go-sqlmock**: SQL数据库Mock

### 安装依赖
```bash
go mod init my-project

# 测试依赖
go get github.com/stretchr/testify
go get github.com/golang/mock/gomock
go get github.com/DATA-DOG/go-sqlmock
```

### 常用命令
```bash
# 运行所有测试
go test ./...

# 运行特定包的测试
go test ./internal/user

# 运行特定测试函数
go test -run TestUser_ValidateEmail

# 显示详细输出
go test -v ./...

# 生成覆盖率报告
go test -cover ./...

# 运行基准测试
go test -bench=. ./...

# 检查竞态条件
go test -race ./...
```

## 🌟 实际项目示例

让我们看一个完整的Go项目测试示例：

**用户验证服务的完整测试**:

```go
package user

import (
    "testing"
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/mock"
)

// TestUserValidator_ValidateEmail demonstrates comprehensive email validation testing
func TestUserValidator_ValidateEmail(t *testing.T) {
    validator := NewUserValidator()
    
    tests := []struct {
        name        string
        email       string
        expectValid bool
        expectError string
    }{
        {
            name:        "valid_standard_email",
            email:       "user@example.com",
            expectValid: true,
            expectError: "",
        },
        {
            name:        "valid_subdomain_email", 
            email:       "user@mail.example.com",
            expectValid: true,
            expectError: "",
        },
        {
            name:        "invalid_missing_at_symbol",
            email:       "userexample.com",
            expectValid: false,
            expectError: "invalid email format",
        },
        {
            name:        "invalid_empty_email",
            email:       "",
            expectValid: false,
            expectError: "email cannot be empty",
        },
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            isValid, err := validator.ValidateEmail(tt.email)
            
            assert.Equal(t, tt.expectValid, isValid)
            if tt.expectError != "" {
                assert.Error(t, err)
                assert.Contains(t, err.Error(), tt.expectError)
            } else {
                assert.NoError(t, err)
            }
        })
    }
}
```

这个工具链为Go项目提供了完整的测试开发框架，帮助您创建高质量、可维护的Go测试代码！🎉

## 🔗 更多资源

- [Go Testing官方文档](https://golang.org/pkg/testing/)
- [Testify库文档](https://github.com/stretchr/testify)
- [GoMock使用指南](https://github.com/golang/mock)
- [Go测试最佳实践](https://golang.org/doc/tutorial/add-a-test)
