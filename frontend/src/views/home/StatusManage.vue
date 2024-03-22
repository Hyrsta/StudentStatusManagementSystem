<template>
    <div>
        <el-table :data="tableData" @cell-mouse-enter="handleCellEnter" @cell-mouse-leave="handleCellLeave"
            @cell-click="handleCellClick" :cell-style="{ padding: '4px 0' }">
            <el-table-column prop="sno" label="学号">
                <template v-slot="{ row }">
                    <el-input class="editable-cell__input" v-model="row.sno" placeholder="请输入内容"></el-input>
                    <div class="editable-cell__val">{{ row.sno }}</div>
                </template>
            </el-table-column>
            <el-table-column prop="sname" label="姓名">
                <template v-slot="{ row }">
                    <el-input class="editable-cell__input" v-model="row.sname" placeholder="请输入内容"></el-input>
                    <div class="editable-cell__val">{{ row.sname }}</div>
                </template>
            </el-table-column>
            <el-table-column prop="sgender" label="性别">
                <template v-slot="{ row }">
                    <el-input class="editable-cell__input" v-model="row.sgender" placeholder="请输入内容"></el-input>
                    <div class="editable-cell__val">{{ row.sgender }}</div>
                </template>
            </el-table-column>
            <el-table-column prop="syear" label="年级">
                <template v-slot="{ row }">
                    <el-input class="editable-cell__input" v-model="row.syear" placeholder="请输入内容"></el-input>
                    <div class="editable-cell__val">{{ row.syear }}</div>
                </template>
            </el-table-column>
            <el-table-column prop="sclno" label="班级">
                <template v-slot="{ row }">
                    <el-input class="editable-cell__input" v-model="row.sclno" placeholder="请输入内容"></el-input>
                    <div class="editable-cell__val">{{ row.sclno }}</div>
                </template>
            </el-table-column>
            <el-table-column prop="sbirth" label="出生日期">
                <template v-slot="{ row }">
                    <el-input class="editable-cell__input" v-model="row.sbirth" placeholder="请输入内容"></el-input>
                    <div class="editable-cell__val">{{ row.sbirth }}</div>
                </template>
            </el-table-column>
            <el-table-column prop="spolitic" label="政治面貌">
                <template v-slot="{ row }">
                    <el-input class="editable-cell__input" v-model="row.spolitic" placeholder="请输入内容"></el-input>
                    <div class="editable-cell__val">{{ row.spolitic }}</div>
                </template>
            </el-table-column>
            <el-table-column prop="sethnic" label="民族">
                <template v-slot="{ row }">
                    <el-input class="editable-cell__input" v-model="row.sethnic" placeholder="请输入内容"></el-input>
                    <div class="editable-cell__val">{{ row.sethnic }}</div>
                </template>
            </el-table-column>
            <el-table-column label="操作" align="center" min-width="140px">
                <template v-slot="{ row }">
                    <el-button @click="save(row)" :disabled="!row.isEdit" type="text" size="small">保存</el-button>
                    <el-button @click="del(row)" :disabled="!row.old_sno" type="text" size="small">删除</el-button>
                </template>
            </el-table-column>
        </el-table>
    </div>
</template>
  
<script>
export default {
    name: "ClickEdit",
    components: {},
    props: {},
    filters: {
        foodLabel(val) {
            return optionsMap.get(val)
        }
    },
    data() {
        return {
            // 表格数据
            tableData: [],
            // 需要编辑的属性
            editProp: ['sno', 'sname', 'sgender', 'syear', 'sclno', 'sbirth', 'spolitic', 'sethnic'],
            // 保存进入编辑的cell
            editCells: new Map()
        }
    },
    computed: {
    },
    methods: {
        /** 鼠标移入cell */
        handleCellEnter(row, column, cell, event) {
            const property = column.property
            if (this.editProp.includes(property)) {
                cell.querySelector('.editable-cell__val').classList.add('editable-cell__val--hover')
            }
        },
        /** 鼠标移出cell */
        handleCellLeave(row, column, cell, event) {
            const property = column.property
            if (this.editProp.includes(property)) {
                cell.querySelector('.editable-cell__val').classList.remove('editable-cell__val--hover')
            }
        },
        /** 点击cell */
        handleCellClick(row, column, cell, event) {
            const property = column.property
            if (this.editProp.includes(property)) {
                // 保存cell
                this.saveCellClick(row, cell)
                cell.querySelector('.editable-cell__val').style.display = 'none'
                cell.querySelector('.editable-cell__input').style.display = 'block'
                cell.querySelector('input').focus()
            }
        },
        /** 取消编辑状态 */
        cancelEditable(cell) {
            cell.querySelector('.editable-cell__val').style.display = 'block'
            cell.querySelector('.editable-cell__input').style.display = 'none'
        },
        /** 保存进入编辑的cell */
        saveCellClick(row, cell) {
            if (this.editCells.has(row)) {
                this.editCells.get(row).add(cell)
            } else {
                this.editCells.set(row, new Set([cell]))
            }
            this.updateRowSave(row)
        },
        /** 保存数据 */
        save(row) {
            this.editCells.get(row).forEach(cell => {
                this.cancelEditable(cell)
            })
            this.editCells.delete(row)
            this.updateRowSave(row)
            // 调用API更新
            let username = localStorage.getItem("username")
            let password = localStorage.getItem("password")
            // 如果old_sno非空，说明是已有字段，执行更新；否则执行插入
            if (row.old_sno != null) {
                this.axios({
                    url: "/api/update_status",
                    method: "get",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    params: {
                        username: username,
                        password: password,
                        sno: row.sno,
                        sname: row.sname,
                        sgender: row.sgender,
                        syear: row.syear,
                        sbirth: row.sbirth,
                        spolitic: row.spolitic,
                        sethnic: row.sethnic,
                        sclno: row.sclno,
                        old_sno: row.old_sno
                    },
                }).then((res) => {
                    if (res.data.code === 0) {
                        this.$message({
                            message: "更新成功",
                            type: "success",
                        });
                    }
                    else {
                        this.$message({
                            message: res.data.msg,
                            type: "error",
                        });
                    }
                });
            }
            else {
                this.axios({
                    url: "/api/insert_status",
                    method: "get",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    params: {
                        username: username,
                        password: password,
                        sno: row.sno,
                        sname: row.sname,
                        sgender: row.sgender,
                        syear: row.syear,
                        sbirth: row.sbirth,
                        spolitic: row.spolitic,
                        sethnic: row.sethnic,
                        sclno: row.sclno
                    },
                }).then((res) => {
                    if (res.data.code === 0) {
                        this.$message({
                            message: "插入成功",
                            type: "success",
                        });
                    }
                    else {
                        this.$message({
                            message: res.data.msg,
                            type: "error",
                        });
                    }
                });
            }
            this.refresh()
        },
        // 删除数据
        del(row) {
            let username = localStorage.getItem("username")
            let password = localStorage.getItem("password")
            this.axios({
                url: "/api/delete_status",
                method: "get",
                headers: {
                    "Content-Type": "application/json",
                },
                params: {
                    username: username,
                    password: password,
                    sno: row.sno,
                },
            }).then((res) => {
                if (res.data.code === 0) {
                    this.$message({
                        message: "删除成功",
                        type: "success",
                    });
                }
                else {
                    this.$message({
                        message: res.data.msg,
                        type: "error",
                    });
                }
            });
            this.refresh()
        },
        updateRowSave(row) {
            row.isEdit = this.editCells.has(row)
        },
        // 从后端获取数据
        refresh() {
            let username = localStorage.getItem("username")
            let password = localStorage.getItem("password")
            let api = "/api/query_status_all"
            if (username != "admin") {
                api = "/api/query_status"
            }
            this.axios({
                url: api,
                method: "get",
                headers: {
                    "Content-Type": "application/json",
                },
                params: {
                    username: username,
                    password: password,
                },
            }).then((res) => {
                if (res.data.code === 0) {
                    for (let i = 0; i < res.data.data.length; i++) {
                        // 添加一个old_sno字段，用于更新或删除
                        res.data.data[i].old_sno = res.data.data[i].sno
                        // 转换日期
                        const date = new Date(res.data.data[i].sbirth)
                        const year = date.getFullYear();
                        const month = date.getMonth() + 1;
                        const day = date.getDate();
                        const newDate = `${year}-${month}-${day}`;
                        res.data.data[i].sbirth = newDate
                    }
                    // 如果是管理员，在尾部添加一条空行用于更新
                    if (username === "admin") {
                        res.data.data.push({})
                    }
                    this.tableData = res.data.data
                }
                else {
                    this.$message({
                        message: res.data.msg,
                        type: "error",
                    });
                }
            });
        }
    },
    created() {
    },
    mounted() {
        this.refresh()
    },
    watch: {},
    beforeDestroy() {
    }
}
</script>
  
<style lang="scss" scoped>
.editable-cell__input {
    display: none;

    .el-input__inner {
        padding: 0 8px;
        font-size: 12px;
    }
}

.editable-cell__val {
    box-sizing: border-box;
    height: 32px;
    line-height: 32px;
    border: 1px solid transparent;

    &--hover {
        border-color: #dddddd;
        border-radius: 4px;
        cursor: text;
    }
}
</style>
  