module top;
int a=1;
int b=1;
initial
begin
if (a)
$display("threads #3");
if (b)
$display("threads #3");
end
endmodule
