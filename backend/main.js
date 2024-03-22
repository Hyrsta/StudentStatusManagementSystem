const express = require('express');
const app = express();
const mysql = require('mysql');
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '123456',
    database: 'student'
});
connection.connect();

// 管理员用户名
const ADMIN = 'admin'

// 查询数据库，验证用户名密码是否正确
async function verify(username, password) {
    let flag = false;
    try {
        const result = await tryToLogin(username, password);
        if (result === 1) {
            flag = true;
        }
    } catch (error) {
        throw error;
    }
    return flag;
}

function tryToLogin(username, password) {
    return new Promise((resolve, reject) => {
        connection.query(
            'CALL CheckLogin(?, ?)',
            [username, password],
            (error, results) => {
                if (error) {
                    reject(new Error(`Error during login query: ${error.message}`));
                } else {
                    const resultValue = results[0]?.[0]?.result;
                    if (resultValue !== undefined) {
                        resolve(resultValue);
                    } else {
                        reject(new Error('Invalid result format in database response'));
                    }
                }
            }
        );
    });
}

// 登录
app.post('/api/login', async function (req, res) {
    try {
        let username = req.query.username;
        let password = req.query.password;
        console.log("收到登录请求");
        try {
            let flag = await verify(username, password);
            if (flag) {
                console.log("登录成功");
                res.json({
                    code: 0,
                    msg: "登录成功",
                    data: {
                        username: username,
                        password: password
                    }
                });
            } else {
                console.log("登录失败");
                res.json({
                    code: -1,
                    msg: "用户名或密码错误",
                    data: null
                });
            }
        } catch (e) {
            console.error(`Error during login: ${e.message}`);
            res.json({
                code: -1,
                msg: "用户名或密码错误",
                data: null
            });
        }
    } catch (e) {
        console.error(`Server internal error: ${e.message}`);
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        });
    }
});

var server = app.listen(4000, function () {
    console.log("后端启动成功")
})

/**
 * 后端采用无状态设计，每次调用API都需要带上用户名和密码，不采用token机制。
 */

// 查询所有学生的学籍信息
app.get('/api/query_status_all', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断用户是否有查询全部学籍的权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有查询所有学生学籍的权限",
                data: null
            })
            return
        }
        // 执行查询
        connection.query('select * from student', (error, results, fields) => {
            if (error) {
                throw error
            } else {
                res.json({
                    code: 0,
                    msg: "",
                    data: results
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 查询某个用户的学籍信息，用户名和学号相同
app.get('/api/query_status', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 执行查询
        connection.query('select * from student where sno = ?', [username], (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "",
                    data: results
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 插入学籍信息
app.get('/api/insert_status', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断是否有插入学籍权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有插入学生学籍的权限",
                data: null
            })
            return
        }
        // 执行插入
        connection.query('insert into student values (?, ?, ?, ?, ?, ?, ?, ?)', [req.query.sno, req.query.sname, req.query.sgender, req.query.syear, req.query.sbirth, req.query.spolitic, req.query.sethnic, req.query.sclno], (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "插入成功",
                    data: null
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 更新学籍信息
app.get('/api/update_status', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断是否有更新学籍权限
        if (username != ADMIN && username != req.query.sno) {
            res.json({
                code: -2,
                msg: "您没有更新学籍的权限",
                data: null
            })
            return
        }
        // 执行更新
        connection.query('update student set sno=?, sname=?, sgender=?, syear=?, sbirth=?, spolitic=?, sethnic=?, sclno=? where sno = ?', [req.query.sno, req.query.sname, req.query.sgender, req.query.syear, req.query.sbirth, req.query.spolitic, req.query.sethnic, req.query.sclno, req.query.old_sno], (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "更新成功",
                    data: null
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 删除学籍信息
app.get('/api/delete_status', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断是否有删除学籍权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有删除学籍的权限",
                data: null
            })
            return
        }
        // 执行删除
        connection.query('delete from student where sno = ?', [req.query.sno], (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "删除成功",
                    data: null
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 获取所有班级
app.get('/api/get_class', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        connection.query('select clno from class', (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "",
                    data: results
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 获取某班级性别分组数据
app.get('/api/get_class_gender', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断是否有权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有查询统计信息的权限",
                data: null
            })
            return
        }
        connection.query('select sgender, count(*) value from student inner join class on student.sclno = class.clno where clno = ? group by sgender', [req.query.clno], (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "",
                    data: results
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 获取某班级出生日期分组数据
app.get('/api/get_class_birth', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断是否有权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有查询统计信息的权限",
                data: null
            })
            return
        }
        connection.query('select sbirth, count(*) value from student inner join class on student.sclno = class.clno where clno = ? group by sbirth', [req.query.clno], (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "",
                    data: results
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 获取某班级政治面貌分组数据
app.get('/api/get_class_politic', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断是否有权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有查询统计信息的权限",
                data: null
            })
            return
        }
        connection.query('select spolitic, count(*) value from student inner join class on student.sclno = class.clno where clno = ? group by spolitic', [req.query.clno], (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "",
                    data: results
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 获取某班级民族分组数据
app.get('/api/get_class_ethnic', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断是否有权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有查询统计信息的权限",
                data: null
            })
            return
        }
        connection.query('select sethnic, count(*) value from student inner join class on student.sclno = class.clno where clno = ? group by sethnic', [req.query.clno], (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "",
                    data: results
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 查询所有学生的成绩信息
app.get('/api/query_grade_all', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断用户是否有查询全部成绩的权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有查询所有学生成绩的权限",
                data: null
            })
            return
        }
        // 执行查询
        connection.query('select sno, sname, cno, cname, ccredit, score from student_course_grade', (error, results, fields) => {
            if (error) {
                throw error
            } else {
                res.json({
                    code: 0,
                    msg: "",
                    data: results
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 查询某个用户的成绩信息，用户名和学号相同
app.get('/api/query_grade', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 执行查询
        connection.query('select sno, sname, cno, cname, ccredit, score from student_course_grade where sno = ?', [username], (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json(results)
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 插入成绩信息
app.get('/api/insert_grade', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断是否有插入成绩权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有插入学生成绩的权限",
                data: null
            })
            return
        }
        // 执行插入
        connection.query('insert into grade values (?, ?, ?)', [req.query.sno, req.query.cno, req.query.score], (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "插入成功",
                    data: null
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 更新成绩信息
app.get('/api/update_grade', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断是否有更新成绩权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有更新学生成绩的权限",
                data: null
            })
            return
        }
        // 执行更新
        connection.query('update grade set sno = ?, cno = ?, score = ? where sno = ? and cno = ?', [req.query.sno, req.query.cno, req.query.score, req.query.old_sno, req.query.old_cno], (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "更新成功",
                    data: null
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 删除成绩信息
app.get('/api/delete_grade', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断是否有删除成绩权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有删除成绩的权限",
                data: null
            })
            return
        }
        // 执行删除
        connection.query('delete from grade where sno = ? and cno = ?', [req.query.sno, req.query.cno], (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "删除成功",
                    data: null
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 获取所有课程
app.get('/api/get_course', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        connection.query('select cno, cname from course', (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "",
                    data: results
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 查询某个班级某门课程所有学生的成绩信息
app.get('/api/query_grade_class', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断用户是否有查询成绩的权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有查询所有学生成绩的权限",
                data: null
            })
            return
        }
        // 执行查询
        connection.query('select sno, sname, score from student_course_grade where clno = ? and cno = ? order by score desc', [req.query.clno, req.query.cno], (error, results, fields) => {
            if (error) {
                throw error
            } else {
                res.json({
                    code: 0,
                    msg: "",
                    data: results
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 查询学生所有课程的成绩信息
app.get('/api/query_grade_student', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断用户是否有查询成绩的权限
        if (username != ADMIN && username != req.query.sno) {
            res.json({
                code: -2,
                msg: "您没有查询成绩的权限",
                data: null
            })
            return
        }
        // 执行查询
        connection.query('select cno, cname, ccredit, score from student_course_grade where sno = ? order by score desc', [req.query.sno], (error, results, fields) => {
            if (error) {
                throw error
            } else {
                res.json({
                    code: 0,
                    msg: "",
                    data: results
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})

// 获取所有学生
app.get('/api/get_student', async function (req, res) {
    try {
        let username = req.query.username
        let password = req.query.password
        // 判断用户名密码是否正确
        let flag = await verify(username, password)
        if (!flag) {
            res.json({
                code: -1,
                msg: "登录失效",
                data: null
            })
            return
        }
        // 判断用户是否有获取所有学生的权限
        if (username != ADMIN) {
            res.json({
                code: -2,
                msg: "您没有查询所有学生的权限",
                data: null
            })
            return
        }
        connection.query('select sno, sname from student', (error, results, fields) => {
            if (error) {
                res.json({
                    code: -3,
                    msg: error.sqlMessage,
                    data: null
                })
            } else {
                res.json({
                    code: 0,
                    msg: "",
                    data: results
                })
            }
        });
    }
    catch (e) {
        res.json({
            code: -100,
            msg: "服务器内部错误",
            data: null
        })
    }
})