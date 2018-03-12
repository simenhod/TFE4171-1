//Make your struct here

typedef struct {
    rand bit [0:31] a, b;
    rand bit [0:3] op;
} data_t;

class alu_data;
        //Initialize your struct here
        rand data_t data;

        // Class methods(tasks) go here
        task get(ref bit [0:31] a, ref bit [0:31] b, ref bit [0:3] op);
            a  = data.a;
            b  = data.b;
            op = data.op;
        endtask

        // Constraints
        constraint c1 { data.a inside {[0:65535]}; }
        constraint c2 { data.b inside {[0:65535]}; }
        constraint c3 { data.op inside {[0:8]}; }

endclass: alu_data
