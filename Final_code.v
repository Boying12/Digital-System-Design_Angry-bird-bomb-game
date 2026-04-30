`timescale 1ns / 1ps
module final_project(PS2_CLK,PS2_DATA_value,clk,rst,hsync,vsync,vga_r, vga_g, vga_b,S1,S2,S3,S4,S0,switch,enable_L,out_L,enable_R,out_R,LED);
input clk,PS2_CLK;
input rst;
input PS2_DATA_value;
input S1,S2,S3,S4,S0;
input [3:0]switch;
output hsync, vsync;
output [3:0] vga_r, vga_g, vga_b;
output reg [3:0]enable_L;
output reg[6:0]out_L;
output reg [3:0]enable_R;
output reg[6:0]out_R;
output reg [15:0]LED;
//output reg [15:0]LED;
//output reg [0:3]enable;
//output reg [0:6]segment;
wire pclk;
wire valid;
wire [9:0] h_cnt, v_cnt;
reg [11:0] vga_data;
reg [7:0]ryb;//level 2bird
wire [11:0] angry_bird_dout,bom_bird_dout,speed_bird_dout,pig_dout,pig1_dout,pigking_dout,
            angry_bird1_dout             ,speed_bird1_dout;                 
reg  [13:0] angry_bird_addr,bom_bird_addr,speed_bird_addr,pig_addr,pig1_addr,pigking_addr,
            angry_bird1_addr,             speed_bird1_addr;
reg[6:0]out_R_high;                                                                                                                                                     
wire angry_bird_logo_area,angry_bird1_logo_area,bom_bird_logo_area,speed_bird_logo_area,speed_bird1_logo_area;   
reg  pig_logo_area,pig1_logo_area,pigking_logo_area;              
reg clk_temp1,clk_temp2,clk_seven_temp,clk2;                                 
reg [9:0] angry_bird_x,angry_bird1_x,bom_bird_x,speed_bird_x,speed_bird1_x,pig_x,pigking_x,angry_bird_y,angry_bird1_y,bom_bird_y,speed_bird_y,speed_bird1_y,pig_y,pigking_y;                                                                            
integer debcnt,counter,fly_H,go,flying,counter_clk1,goangry,counter_clk2;
integer      fly_Hbomb,fly_H1,go1,goup,goup1,goangry1,gobomb,speedcnt,angrycnt;
integer angryshow,angryshow1,speedshow,speedshow1,bombshow;
integer enablecnt,move0,move01,touch,move1,move2,move11,move21,move3,counter_seven,counter_LED,stop,brick;
integer datacnt;
reg[9:0] angry_bird_x_temp,bomb_bird_x_temp;
integer i,i1,i2,x,y;
integer close,close_temp;//other
integer ugly_pig1,ugly_pig2,ugly_king,bk1,bk2,bk3,bk4,bk5,bk6,bk7;/////for Level2
integer stopb,stopa,stopa1,stops,stops1,win;
parameter    angry_bird_length=52,
            bom_bird_length=52,
            speed_bird_length=52,
            pig_length=52,
            pigking_length=52,
            angry_bird_high=52,
            bom_bird_high=52,
            speed_bird_high=52,
            pig_high=52,
            pigking_high=52;
          
dcm_25M u0(.clk_in1(clk), .clk_out1(pclk), .reset(!rst));
angry_bird angry(
    .clka(pclk),
    .addra(angry_bird_addr),
    .douta(angry_bird_dout));
bom_bird bom(
    .clka(pclk),
    .addra(bom_bird_addr),
    .douta(bom_bird_dout));
speed_bird speed(
    .clka(pclk),
    .addra(speed_bird_addr),
    .douta(speed_bird_dout));
angry_bird angry1(
    .clka(pclk),
    .addra(angry_bird1_addr),
    .douta(angry_bird1_dout));
speed_bird speed1(
    .clka(pclk),
    .addra(speed_bird1_addr),
    .douta(speed_bird1_dout));
pig pig(
    .clka(pclk),
    .addra(pig_addr),
    .douta(pig_dout));
pig pig1(
    .clka(pclk),
    .addra(pig1_addr),
    .douta(pig1_dout));
kingpig king(
    .clka(pclk),
    .addra(pigking_addr),
    .douta(pigking_dout));
    
    
SyncGeneration Sync(
    .pclk(pclk),
    .reset(!rst),
    .hSync(hsync),
    .vSync(vsync),
    .dataValid(valid),
    .hDataCnt(h_cnt),
    .vDataCnt(v_cnt));

assign angry_bird_logo_area = ((h_cnt>=angry_bird_x)&&(h_cnt<=angry_bird_x+angry_bird_length-1)&&(v_cnt>=angry_bird_y)&&(v_cnt<=angry_bird_y+angry_bird_high-1))?1:0;
assign speed_bird_logo_area = ((h_cnt>=speed_bird_x)&&(h_cnt<=speed_bird_x+speed_bird_length-1)&&(v_cnt>=speed_bird_y)&&(v_cnt<=speed_bird_y+speed_bird_high-1))?1:0;
assign angry_bird1_logo_area = ((h_cnt>=angry_bird1_x)&&(h_cnt<=angry_bird1_x+angry_bird_length-1)&&(v_cnt>=angry_bird1_y)&&(v_cnt<=angry_bird1_y+angry_bird_high-1))?1:0;
assign speed_bird1_logo_area = ((h_cnt>=speed_bird1_x)&&(h_cnt<=speed_bird1_x+speed_bird_length-1)&&(v_cnt>=speed_bird1_y)&&(v_cnt<=speed_bird1_y+speed_bird_high-1))?1:0;
assign bom_bird_logo_area = ((h_cnt>=bom_bird_x)&&(h_cnt<=bom_bird_x+bom_bird_length-1)&&(v_cnt>=bom_bird_y)&&(v_cnt<=bom_bird_y+bom_bird_high-1))?1:0;

always@(posedge pclk,negedge rst)
begin
    if(!rst)
    begin
        pig_logo_area<=0;
    end
    else
    begin
        if ((h_cnt>=361 && h_cnt<=412) && (v_cnt>=361 && v_cnt<=412) && switch[3]==1)
           pig_logo_area<=1; 
        else
            pig_logo_area<=0;
    end
end
always@(posedge pclk,negedge rst)
begin
    if(!rst)
    begin
        pig1_logo_area<=0;
    end
    else
    begin
        if ((h_cnt>=241 && h_cnt<=292) && (v_cnt>=361 && v_cnt<=412) && switch[3]==1)
           pig1_logo_area<=1; 
        else
            pig1_logo_area<=0;
    end
end
always@(posedge pclk,negedge rst)
begin
    if(!rst)
    begin
        pigking_logo_area<=0;
    end
    else
    begin
        if ((h_cnt>=421 && h_cnt<=472) && (v_cnt>=65 && v_cnt<=116) && switch[3]==1)
           pigking_logo_area<=1;
        else 
            pigking_logo_area<=0;
    end
end
always@(posedge pclk,negedge rst)
begin
    if(!rst)
    begin
        angry_bird_addr<=0;//14 bit
        speed_bird_addr<=0;//14 bit
        bom_bird_addr<=0;//14 bit
        pig_addr<=0;//14 bit
        pig1_addr<=0;//14 bit
        pigking_addr<=0;//14 bit
        vga_data<=0;//12 bit
        brick<=0;
    end 
    else
    begin
        if(valid==1) 
        begin
            if (switch[3]==0)
            begin
                if(angry_bird_logo_area==1&&((switch[1]==1&&switch[0]==0)||goangry==1))
                begin
                    angry_bird_addr<=angry_bird_addr+1;
                    vga_data<=angry_bird_dout;
                end 
                else if(speed_bird_logo_area==1&&((switch[1]==0&&switch[0]==1)||go==1))
                begin
                    speed_bird_addr<=speed_bird_addr+1;
                    vga_data<=speed_bird_dout;
                end 
                else 
                begin
                    if ((h_cnt >= 1 && h_cnt <= 4) || (h_cnt >= 57 && h_cnt <= 60) || (h_cnt >= 117 && h_cnt <= 120) || (h_cnt >= 177 && h_cnt <= 180) || (h_cnt >= 237 && h_cnt <= 240) || (h_cnt >= 297 && h_cnt <= 300) 
                    || (h_cnt >= 357 && h_cnt <= 360)|| (h_cnt >= 417 && h_cnt <= 420)|| (h_cnt >= 477 && h_cnt <= 480))
                    begin
                            vga_data <= 12'h00A;     
                    end 
                    else if ((v_cnt >= 1 && v_cnt <= 4) || (v_cnt >= 57 && v_cnt <= 60) || (v_cnt >= 117 && v_cnt <= 120) || (v_cnt >= 177 && v_cnt <= 180) || (v_cnt >= 237 && v_cnt <= 240) || (v_cnt >= 297 && v_cnt <= 300) 
                        || (v_cnt >= 357 && v_cnt <= 360)|| (v_cnt >= 417 && v_cnt <= 420)|| (v_cnt >= 477 && v_cnt <= 480))
                    begin
                            vga_data <= 12'h00A;     
                    end
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 181 && h_cnt <= 236)&&(speed_bird_x<176||speed_bird_y!=425)&&(angry_bird_x!=185||angry_bird_y!=425))
                    begin
                            vga_data <= 12'hA50;        
                    end 
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 181 && h_cnt <= 236)&&(speed_bird_x>=176&&speed_bird_y==425)&&(angry_bird_x==185||angry_bird_y==425))
                    begin
                            vga_data <= 12'hFFF;        
                    end
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 241 && h_cnt <= 296)&&(speed_bird_x<236||speed_bird_y!=425)&&(angry_bird_x!=245||angry_bird_y!=425))
                    begin
                            vga_data <= 12'hA50;        
                    end 
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 241 && h_cnt <= 296)&&speed_bird_x>=236&&speed_bird_y==425&&(angry_bird_x==245||angry_bird_y==425))
                    begin
                            vga_data <= 12'hFFF;        
                    end 
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 301 && h_cnt <= 356)&&(speed_bird_x<296||speed_bird_y!=425)&&(angry_bird_x!=305||angry_bird_y!=425))
                    begin
                            vga_data <= 12'hA50;        
                    end 
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 301 && h_cnt <= 356)&&speed_bird_x>=296&&speed_bird_y==425&&(angry_bird_x==305||angry_bird_y==425))
                    begin
                            vga_data <= 12'hFFF;        
                    end
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 361 && h_cnt <= 416)&&(speed_bird_x<356||speed_bird_y!=425)&&(angry_bird_x!=365||angry_bird_y!=425))
                    begin
                            vga_data <= 12'hA50;        
                    end 
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 361 && h_cnt <= 416)&&speed_bird_x>=356&&speed_bird_y==425&&(angry_bird_x==365||angry_bird_y==425))
                    begin
                            vga_data <= 12'hFFF;        
                    end
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 421 && h_cnt <= 476)&&(speed_bird_x<416||speed_bird_y!=425)&&(angry_bird_x!=425||angry_bird_y!=425))
                    begin
                            vga_data <= 12'hA50;        
                    end 
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 421 && h_cnt <= 476)&&speed_bird_x>362&&speed_bird_y==425&&(angry_bird_x==425||angry_bird_y==425))
                    begin
                            vga_data <= 12'hFFF;        
                    end
               
                    else if(((v_cnt >= 361 && v_cnt <= 416) && (h_cnt >= 301 && h_cnt <= 356))&&(speed_bird_x<296||speed_bird_y!=365)&&(angry_bird_x!=305||angry_bird_y!=365))
                    begin
                            vga_data <= 12'hA50;
                    end
                    else if(((v_cnt >= 361 && v_cnt <= 416) && (h_cnt >= 301 && h_cnt <= 356))&&speed_bird_x>=296&&speed_bird_y==365&&(angry_bird_x==305||angry_bird_y==365))
                    begin
                                vga_data <= 12'hFFF;     
                                brick<=1;   
                    end
                    else if (((v_cnt >= 301 && v_cnt <= 476) && (h_cnt >= 5 && h_cnt <= 56)))
                        vga_data <= 12'hFD0;/////黃色
                    else if ( v_cnt <= 480 && h_cnt <= 480)
                        vga_data <= 12'hFFF;
                    else
                        vga_data <= 12'h000;
                end
            end//switch3end
            else
            begin
                if(angry_bird_logo_area==1 && (angryshow==1 || goangry==1))
                begin
                    angry_bird_addr<=angry_bird_addr+1;
                    vga_data<=angry_bird_dout;
                end 
                else if(speed_bird_logo_area==1 && (speedshow==1 || go==1 || goup==1))
                begin
                    speed_bird_addr<=speed_bird_addr+1;
                    vga_data<=speed_bird_dout;
                end 
                else if(angry_bird1_logo_area==1 && (angryshow1==1 || goangry1==1))
                begin
                    angry_bird1_addr<=angry_bird1_addr+1;
                    vga_data<=angry_bird1_dout;
                end 
                else if(speed_bird1_logo_area==1 && (speedshow1==1 || go1==1 || goup1==1))
                begin
                    speed_bird1_addr<=speed_bird1_addr+1;
                    vga_data<=speed_bird1_dout;
                end 
                else if(bom_bird_logo_area==1 && (bombshow==1 || gobomb==1))
                begin
                    bom_bird_addr<=bom_bird_addr+1;
                    vga_data<=bom_bird_dout;
                end 
                else if(pig_logo_area==1&&ugly_pig2==0)
                begin
                    pig_addr<=pig_addr+1;
                    vga_data<=pig_dout;
                end 
                else if(pig1_logo_area==1&&ugly_pig1==0)
                begin
                    pig1_addr<=pig1_addr+1;
                    vga_data<=pig1_dout;
                end 
                else if(pigking_logo_area==1&&ugly_king==0)
                begin
                    pigking_addr<=pigking_addr+1;
                    vga_data<=pigking_dout;
                end
                else 
                begin
                    if ((h_cnt >= 1 && h_cnt <= 4) || (h_cnt >= 57 && h_cnt <= 60) || (h_cnt >= 117 && h_cnt <= 120) || (h_cnt >= 177 && h_cnt <= 180) || (h_cnt >= 237 && h_cnt <= 240) || (h_cnt >= 297 && h_cnt <= 300) 
                    || (h_cnt >= 357 && h_cnt <= 360)|| (h_cnt >= 417 && h_cnt <= 420)|| (h_cnt >= 477 && h_cnt <= 480))
                    begin
                            vga_data <= 12'h00A;//blue     
                    end 
                    else if ((v_cnt >= 1 && v_cnt <= 4) || (v_cnt >= 57 && v_cnt <= 60) || (v_cnt >= 117 && v_cnt <= 120) || (v_cnt >= 177 && v_cnt <= 180) || (v_cnt >= 237 && v_cnt <= 240) || (v_cnt >= 297 && v_cnt <= 300) 
                        || (v_cnt >= 357 && v_cnt <= 360)|| (v_cnt >= 417 && v_cnt <= 420)|| (v_cnt >= 477 && v_cnt <= 480))
                    begin
                            vga_data <= 12'h00A;     
                    end
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 181 && h_cnt <= 236) && bk3==0)//bk3
                    begin
                            vga_data <= 12'hA50;        
                    end 
                    
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 241 && h_cnt <= 296) && bk4==0)//bk4
                    begin
                            vga_data <= 12'hA50;        
                    end 
                    
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 301 && h_cnt <= 356) && bk5==0)//bk5
                    begin
                            vga_data <= 12'hA50;        
                    end 
                    
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 361 && h_cnt <= 416) && bk6==0)//bk6
                    begin
                            vga_data <= 12'hA50;        
                    end 
                    
                    else if ((v_cnt >= 421 && v_cnt <= 476)&&(h_cnt >= 421 && h_cnt <= 476) && bk7==0)//bk7
                    begin
                            vga_data <= 12'hA50;        
                    end 
                    
                    else if(((v_cnt >= 361 && v_cnt <= 416) && (h_cnt >= 301 && h_cnt <= 356)) && bk1==0)//bk1
                    begin
                            vga_data <= 12'hA50;
                    end
                    else if(((v_cnt >= 361 && v_cnt <= 416) && (h_cnt >= 421 && h_cnt <= 476)) && bk2==0)//bk2
                    begin
                            vga_data <= 12'hA50;
                    end
                    
                    else if ((v_cnt >= 301 && v_cnt <= 476 && h_cnt >= 5 && h_cnt <= 56) || (v_cnt >= 421 && v_cnt <= 476 && h_cnt >= 61 && h_cnt <= 176))
                        vga_data <= 12'hFD0;/////黃色
                    else if ( v_cnt <= 480 && h_cnt <= 480)
                        vga_data <= 12'hFFF;
                    else
                        vga_data <= 12'h000;
                end
            end//else switch3end
        end//valid end 
        else
        begin
            vga_data <= 0;
            if(v_cnt==0) 
            begin
                angry_bird_addr<=0;
                speed_bird_addr<=0;
                angry_bird1_addr<=0;
                speed_bird1_addr<=0;
                bom_bird_addr<=0;
                pig_addr<=0;
                pig1_addr<=0;
                pigking_addr<=0;
            end 
            else
            begin
                angry_bird_addr<=angry_bird_addr;
                speed_bird_addr<=speed_bird_addr;
                angry_bird1_addr<=angry_bird1_addr;
                speed_bird1_addr<=speed_bird1_addr;
                bom_bird_addr<=bom_bird_addr;
                pig_addr<=pig_addr;
                pig1_addr<=pig1_addr;
                pigking_addr<=pigking_addr;
            end
        end
    end//else rst end
end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Level 2勝利
always@(*)
begin
    if((ugly_pig1==1&&ugly_pig2==1)||ugly_king==1)
        win=1;
    else
        win=0;    
end


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////判斷撞擊磚頭
always@(*)
begin
    if(bom_bird_x==425&&bom_bird_y==125&&stopb==1)
    begin
        ugly_king=1;   
    end 
    else 
        ugly_king=0;
end
always@(*)
begin
    if((angry_bird_x==245&&angry_bird_y==365)||(angry_bird1_x==245&&angry_bird1_y==365)||(speed_bird_x>=245&&speed_bird_y==365)||(speed_bird1_x>=245&&speed_bird1_y==365)
            ||(bom_bird_x==245&&bom_bird_y==365&&stopb==1)||(bom_bird_x==185&&bom_bird_y==425&&stopb==1)||(bom_bird_x==245&&bom_bird_y==425&&stopb==1)||(bom_bird_x==305&&bom_bird_y==365&&stopb==1)||ugly_king==1)
    begin
        ugly_pig1=1;
    end else
        ugly_pig1=0;
end
always@(*)
begin
    if((angry_bird_x==365&&angry_bird_y==365)||(angry_bird1_x==365&&angry_bird1_y==365)||(speed_bird_x>=365&&speed_bird_y==365)||(speed_bird1_x>=365&&speed_bird1_y==365)
            ||(bom_bird_x==305&&bom_bird_y==365&&stopb==1)||(bom_bird_x==365&&bom_bird_y==365&&stopb==1)||(bom_bird_x==425&&bom_bird_y==365&&stopb==1)||(bom_bird_x==425&&bom_bird_y==305&&stopb==1)
            ||(bom_bird_x==305&&bom_bird_y==425&&stopb==1)||(bom_bird_x==365&&bom_bird_y==425&&stopb==1)||ugly_king==1)
    begin
        ugly_pig2=1;
    end else
        ugly_pig2=0;
end
always@(*)
begin
    if((angry_bird_x==305&&angry_bird_y==365)||(angry_bird1_x==305&&angry_bird1_y==365)||(speed_bird_x>=305&&speed_bird_y==365)||(speed_bird1_x>=305&&speed_bird1_y==365)
       ||(bom_bird_x==245&&bom_bird_y==365&&stopb==1)||(bom_bird_x==305&&bom_bird_y==365&&stopb==1)||(bom_bird_x==365&&bom_bird_y==365&&stopb==1)||(bom_bird_x==245&&bom_bird_y==425&&stopb==1)
       ||(bom_bird_x==305&&bom_bird_y==425&&stopb==1)||(bom_bird_x==365&&bom_bird_y==425&&stopb==1))
       begin
            bk1=1;
       end else 
            bk1=0;
end
always@(*)
begin
    if((angry_bird_x==425&&angry_bird_y==365)||(angry_bird1_x==425&&angry_bird1_y==365)||(speed_bird_x>=425&&speed_bird_y==365)||(speed_bird1_x>=425&&speed_bird1_y==365)
       ||(bom_bird_x==425&&bom_bird_y==305&&stopb==1)||(bom_bird_x==365&&bom_bird_y==365&&stopb==1)||(bom_bird_x==425&&bom_bird_y==365&&stopb==1)||(bom_bird_x==365&&bom_bird_y==425&&stopb==1)
       ||(bom_bird_x==425&&bom_bird_y==425&&stopb==1))
       begin
            bk2=1;
       end else 
            bk2=0;
end
always@(*)
begin
    if((angry_bird_x==185&&angry_bird_y==425)||(angry_bird1_x==185&&angry_bird1_y==425)||(speed_bird_x>=185&&speed_bird_y==425)||(speed_bird1_x>=185&&speed_bird1_y==425)
       ||(bom_bird_x==125&&bom_bird_y==425&&stopb==1)||(bom_bird_x==185&&bom_bird_y==425&&stopb==1)||(bom_bird_x==245&&bom_bird_y==425&&stopb==1)||(bom_bird_x==245&&bom_bird_y==365&&stopb==1))
       begin
            bk3=1;
       end else 
            bk3=0;
end
always@(*)
begin
    if((angry_bird_x==245&&angry_bird_y==425)||(angry_bird1_x==245&&angry_bird1_y==425)||(speed_bird_x>=245&&speed_bird_y==425)||(speed_bird1_x>=245&&speed_bird1_y==425)
       ||(bom_bird_x==185&&bom_bird_y==425&&stopb==1)||(bom_bird_x==245&&bom_bird_y==425&&stopb==1)||(bom_bird_x==305&&bom_bird_y==425&&stopb==1)||(bom_bird_x==245&&bom_bird_y==365&&stopb==1)
       ||(bom_bird_x==305&&bom_bird_y==365&&stopb==1))
       begin
            bk4=1;
       end else 
            bk4=0;
end
always@(*)
begin
    if((angry_bird_x==305&&angry_bird_y==425)||(angry_bird1_x==305&&angry_bird1_y==425)||(speed_bird_x>=305&&speed_bird_y==425)||(speed_bird1_x>=305&&speed_bird1_y==425)
       ||(bom_bird_x==245&&bom_bird_y==425&&stopb==1)||(bom_bird_x==305&&bom_bird_y==425&&stopb==1)||(bom_bird_x==365&&bom_bird_y==425&&stopb==1)||(bom_bird_x==245&&bom_bird_y==365&&stopb==1)
       ||(bom_bird_x==305&&bom_bird_y==365&&stopb==1)||(bom_bird_x==365&&bom_bird_y==365&&stopb==1))
       begin
            bk5=1;
       end else 
            bk5=0;
end
always@(*)
begin
    if((angry_bird_x==365&&angry_bird_y==425)||(angry_bird1_x==365&&angry_bird1_y==425)||(speed_bird_x>=365&&speed_bird_y==425)||(speed_bird1_x>=365&&speed_bird1_y==425)
       ||(bom_bird_x==425&&bom_bird_y==425&&stopb==1)||(bom_bird_x==305&&bom_bird_y==425&&stopb==1)||(bom_bird_x==365&&bom_bird_y==425&&stopb==1)||(bom_bird_x==425&&bom_bird_y==365&&stopb==1)
       ||(bom_bird_x==305&&bom_bird_y==365&&stopb==1)||(bom_bird_x==365&&bom_bird_y==365&&stopb==1))
       begin
            bk6=1;
       end else 
            bk6=0;
end
always@(*)
begin
    if((angry_bird_x==425&&angry_bird_y==425)||(angry_bird1_x==425&&angry_bird1_y==425)||(speed_bird_x>=425&&speed_bird_y==425)||(speed_bird1_x>=425&&speed_bird1_y==425)
       ||(bom_bird_x==365&&bom_bird_y==365&&stopb==1)||(bom_bird_x==425&&bom_bird_y==365&&stopb==1)||(bom_bird_x==365&&bom_bird_y==425&&stopb==1)||(bom_bird_x==425&&bom_bird_y==425&&stopb==1))
       begin
            bk7=1;
       end else 
            bk7=0;
end

always @(negedge PS2_CLK,negedge rst)
begin
    if (!rst)
    begin
        datacnt<=0;
        ryb<=0;
    end
    else if (datacnt>=9)
        datacnt<=0;
    else if (datacnt<=8 && datacnt>=1)
    begin
        ryb[datacnt-1]<=PS2_DATA_value;
        datacnt<=datacnt+1;
    end  
    else if (PS2_DATA_value==0)
        datacnt<=datacnt+1;
    else
        datacnt<=datacnt;      
end

assign {vga_r, vga_g, vga_b} = vga_data;

always @(posedge pclk, negedge rst)//button debounce
begin
    if (!rst)
        debcnt<=0;
    else 
    begin
        if (S4  || S3  || S0  || S2 || S1)
            debcnt<=debcnt+1;
        else
            debcnt<=0;
    end
end

always @(posedge pclk, negedge rst)//button debounce
begin
    if (!rst)
    begin
        speedshow<=0;
        speedshow1<=0;
        angryshow<=0;
        angryshow1<=0;
        bombshow<=0;
        speedcnt<=0;
        angrycnt<=0;
        close_temp<=0;
        i2<=0;
    end
    else 
    begin   
        if(switch[3]==1&&win==0)
        begin
             if (switch[1]==0 && switch[0]==0)
            begin
                speedshow<=0;
                speedshow1<=0;
                angryshow<=0;
                angryshow1<=0;
                speedcnt<=0;
                angrycnt<=0;
                if (ryb==8'b00110010 || gobomb==1)
                begin
                    bombshow<=1;
                end
                else
                    i<=0;
            end
            else if (switch[1]==0 && switch[0]==1)
            begin
                speedshow1<=0;
                angryshow1<=0;
                case(ryb)
                8'b00101101:
                begin
                    angryshow<=1;
                    if (go==0 && goup==0)
                        speedshow<=0;
                    if (gobomb==0)
                        bombshow<=0;
                end
                8'b00110101:
                begin
                     speedshow<=1;
                    if (goangry==0)
                        angryshow<=0;
                    if (gobomb==0)
                        bombshow<=0;
                end
                8'b00110010:
                begin
                    bombshow<=1;
                    if (go==0 && goup==0)
                        speedshow<=0;
                    if (goangry==0)
                        angryshow<=0;
                end
                default:i2<=0;
                endcase
                if (goangry==1)//Red
                begin
                    angryshow<=1;
                end
                else i<=0;
                if (go==1||goup==1)//Yellow
                begin
                    speedshow<=1;
                end 
                else i<=0;
                if (gobomb==1)//Black
                    bombshow<=1;
                else i2<=0;
            end
            else if (switch[1]==1 && switch[0]==0)
            begin
                    if (ryb==8'b11110000)
                    begin
                            close_temp<=2;
                    end
                    else i2<=0;
                    case(ryb)
                    8'b00101101:///////R
                        begin  
                            if (angrycnt==1)//&&close_temp==2)
                            begin
                                angryshow1<=1;
                                close_temp<=1;
                                if (goangry1==1)
                                    angrycnt<=angrycnt+1;
                            end
                            else if (angrycnt==0&&close_temp==2)
                            begin
                                close_temp<=1;
                                angryshow<=1;
                                if (goangry==1)
                                    angrycnt<=angrycnt+1;
                                if (go==0 && goup==0)
                                    speedshow<=0;
                                if (go1==0 && goup1==0)
                                    speedshow1<=0;
                                if (gobomb==0)
                                    bombshow<=0;
                            end
                        end
                    8'b00110101://Y
                        begin   
                            
                            if (speedcnt==1)//&&close_temp==2)
                            begin
                                speedshow1<=1;
                                close_temp<=1;
                                if (go1==1 || goup1==1)
                                    speedcnt<=speedcnt+1;
                                if (goangry==0)
                                    angryshow<=0;
                                if (goangry1==0)
                                    angryshow1<=0;
                                if (gobomb==0)
                                    bombshow<=0;
                            end
                            else if (speedcnt==0&&close_temp==2)
                            begin
                                speedshow<=1;
                                close_temp<=1;
                                if (go==1 || goup==1)
                                    speedcnt<=speedcnt+1;
                                if (goangry==0)
                                    angryshow<=0;
                                if (goangry1==0)
                                    angryshow1<=0;
                                if (gobomb==0)
                                    bombshow<=0;
                            end
                        end
                    8'b00110010://B
                        begin   
                            if(close_temp==2)
                            begin
                                bombshow<=1;
                                if (goangry==0)
                                        angryshow<=0;
                                if (goangry1==0)
                                        angryshow1<=0;
                                if (go==0 && goup==0)
                                        speedshow<=0;
                                if (go1==0 && goup1==0)
                                        speedshow1<=0;
                            end
                        end
                    default:close_temp<=2;
                    endcase
                    //end
                    if ( goangry==1)//Red
                    begin
                            angryshow<=1;  
                    end 
                    else i2<=0;
                    if ( goangry1==1)//Red
                    begin
                            angryshow1<=1; 
                    end
                    else i2<=0;
                    if (go==1 || goup==1)//Yellow
                    begin
                            speedshow<=1;    
                    end
                    else i2<=0;
                    if (go1==1 || goup1==1)//Yellow
                    begin
                            speedshow1<=1;    
                    end
                    else i2<=0;
                    if (gobomb==1)//Black
                    begin
                        bombshow<=1;
                    end
                    else i2<=0;
                end//10end
        end //switchend
        else
            i<=0;
       
    end//else rstend
end

always@(posedge clk_temp1,negedge rst) ////////////////////////////////////////////////////////////////////////////////////////////////////紅色鳥的行為
begin
    if(!rst)
    begin
        angry_bird_x<=641;
        angry_bird_y<=641;
        angry_bird_x_temp<=641;
        angry_bird1_x<=641;
        angry_bird1_y<=641;
        touch<=0;
        stopa<=0;
        stopa1<=0;
    end 
    else
    begin
        if (switch[3]==0)
        begin
            if (goangry==0&&switch[1]==1&&switch[0]==0)
            begin
                angry_bird_x<=10'd5;
                angry_bird_y<=10'd425-move0;
                angry_bird_x_temp<=angry_bird_x;
            end
            else if (goangry==1&&switch[1]==1&&switch[0]==0)
            begin
                if(angry_bird_x<angry_bird_x_temp+fly_H*60)
                begin
                    angry_bird_x<=angry_bird_x+60;
                    angry_bird_y<=angry_bird_y-60;
                //counter<=counter+1;
                end 
                else if(angry_bird_x>=angry_bird_x_temp+fly_H*60)//&&angry_bird_x!=425&&angry_bird_y!=421
                begin
                    if(angry_bird_x==305&&angry_bird_y==365&&brick==0)
                    begin
                        touch<=1;
                    end  
                    else if(angry_bird_y==425||angry_bird_x==425)
                    touch<=1;
                    else 
                    begin
                        angry_bird_x<=angry_bird_x+60;
                        angry_bird_y<=angry_bird_y+60;          
                    end      
                end
                else
                begin
                    angry_bird_x<=angry_bird_x;
                    angry_bird_y<=angry_bird_y;
                end
            end   
            else
            begin
                angry_bird_x<=angry_bird_x;
                angry_bird_y<=angry_bird_y;
            end
        end//switch3end
        else if(switch[3]==1&&win==0)
        begin
            if (angryshow==1)
            begin
                if (goangry==0)
                begin
                    angry_bird_x<=10'd5;
                    angry_bird_y<=10'd425-move0;
                end
                else if (goangry==1)
                begin
                    if (angry_bird_x<5+fly_H*60 && angry_bird_x<425 && angry_bird_y<425||(angry_bird_x==5 && angry_bird_y==425))
                    begin
                        angry_bird_x<=angry_bird_x+60;
                        angry_bird_y<=angry_bird_y-60;
                    end
                    else if ((bk1==0&&angry_bird_x==245&&angry_bird_y==305)||(ugly_pig1==0&&angry_bird_x==185&&angry_bird_y==305)||(ugly_pig2==0&&angry_bird_x==305&&angry_bird_y==305))
                    begin
                        angry_bird_x<=angry_bird_x+60;
                        angry_bird_y<=angry_bird_y+60;
                        stopa<=1;
                    end
                    else if (angry_bird_x>=5+fly_H*60 && angry_bird_x<425 && angry_bird_y<425 && stopa==0)
                    begin
                        angry_bird_x<=angry_bird_x+60;
                        angry_bird_y<=angry_bird_y+60; 
                    end
                    else
                    begin
                        angry_bird_x<=angry_bird_x;
                        angry_bird_y<=angry_bird_y;
                        stopa<=1;
                    end
                end
                else
                begin
                    angry_bird_x<=angry_bird_x;
                    angry_bird_y<=angry_bird_y;
                    stopa<=1;
                end
            end
            if (angryshow1==1)
            begin
                if (goangry1==0)
                begin
                    angry_bird1_x<=10'd5;
                    angry_bird1_y<=10'd425-move01;
                end
                else if (goangry1==1)
                begin
                    if (angry_bird1_x<5+fly_H1*60 && angry_bird1_x<425 && angry_bird1_y<425||(angry_bird1_x==5 && angry_bird1_y==425))
                    begin
                        angry_bird1_x<=angry_bird1_x+60;
                        angry_bird1_y<=angry_bird1_y-60;
                    end
                    else if ((bk1==0&&angry_bird1_x==245&&angry_bird1_y==305)||(ugly_pig1==0&&angry_bird1_x==185&&angry_bird1_y==305)||(ugly_pig2==0&&angry_bird1_x==305&&angry_bird1_y==305))
                    begin
                        angry_bird1_x<=angry_bird1_x+60;
                        angry_bird1_y<=angry_bird1_y+60;
                        stopa1<=1;
                    end
                    else if (angry_bird1_x>=5+fly_H1*60 && angry_bird1_x<425 && angry_bird1_y<425 && stopa1==0)
                    begin
                        angry_bird1_x<=angry_bird1_x+60;
                        angry_bird1_y<=angry_bird1_y+60; 
                    end
                    else
                        stopa1<=1;
                end
                else
                begin
                    angry_bird1_x<=angry_bird1_x;
                    angry_bird1_y<=angry_bird1_y;
                    stopa1<=1;
                end
            end
        end//else switch3end
    end//else rstend
end

always@(posedge clk_temp2,negedge rst) //////////////////////////////////////////////////////////////////黃色鳥的行為
begin
    if(!rst)
    begin
        speed_bird_y<=641;
        speed_bird1_y<=641;
        i1<=0;
    end else
    begin
        if (switch[3]==0)
        begin
            if(switch[1]==0&&switch[0]==1)
            begin
                if(go==0)
                    speed_bird_y<=10'd425-move1;  
                else
                    speed_bird_y<=speed_bird_y;
            end
            else 
            begin
                speed_bird_y<=speed_bird_y;
            end
        end//switch3end
        else if(switch[3]==1&&win==0)
        begin
            if(speedshow==1)
            begin
                if(go==0&&goup==0)
                    speed_bird_y<=10'd425-move1;  
                else if (go==0&&goup==1&&speed_bird_y>5&&speedshow1!=1)
                    speed_bird_y<=speed_bird_y-60;
                else
                    speed_bird_y<=speed_bird_y;
            end
            else i1<=0;
            if(speedshow1==1)
            begin
                if(go1==0&&goup1==0)
                    speed_bird1_y<=10'd425-move11;  
                else if (go1==0&&goup1==1&&speed_bird1_y>5)
                    speed_bird1_y<=speed_bird1_y-60;
                else
                    speed_bird1_y<=speed_bird1_y;
            end
            else i1<=0;
        end//else switch3end
    end
end
always@(posedge clk_temp2,negedge rst) 
begin
    if(!rst)
    begin
        speed_bird_x<=641;
        speed_bird1_x<=641;
        stops<=0;
        stops1<=0;
    end 
    else
    begin
        if (switch[3]==0)
        begin
            if (go==0&&switch[1]==0&&switch[0]==1)
            begin
                speed_bird_x<=10'd5;
            end
            else if (go==1&&switch[1]==0&&switch[0]==1&&speed_bird_x<=365)
            begin
                speed_bird_x<=speed_bird_x+60;
            end
            else
                speed_bird_x<=speed_bird_x;
        end//switch3end
        else if(switch[3]==1&&win==0)
        begin
            if(speedshow==1)
            begin
                if (go==0&&goup==0)
                begin
                    speed_bird_x<=10'd5+move2;
                end
                else if((ugly_pig1==0&&speed_bird_x==185&&speed_bird_y==365)||(ugly_pig2==0&&speed_bird_x==305&&speed_bird_y==365))
                begin
                    speed_bird_x<=speed_bird_x+60;
                    stops<=1;
                end
                else if (go==1&&goup==0&&speed_bird_x<=365&&speedshow1!=1&&stops==0)
                begin
                    speed_bird_x<=speed_bird_x+60;
                end
                else
                    stops<=1;
            end
            if(speedshow1==1)
            begin
                if (go1==0&&goup1==0)
                begin
                    speed_bird1_x<=10'd5+move21;
                end
                else if((ugly_pig1==0&&speed_bird1_x==185&&speed_bird1_y==365)||(ugly_pig2==0&&speed_bird1_x==305&&speed_bird1_y==365))
                begin
                    speed_bird1_x<=speed_bird1_x+60;
                    stops1<=1;
                end
                else if (go1==1&&goup1==0&&speed_bird1_x<=365&&stops1==0)
                begin
                    speed_bird1_x<=speed_bird1_x+60;
                end
                else
                    stops1<=1;
            end
        end//else switch3end
    end
end

always@(posedge clk_temp1,negedge rst) ////////////////////////////////////////////////////////////////////////////////////////////////////黑色鳥的行為
begin
    if(!rst)
    begin
        bom_bird_x<=641;
        bom_bird_y<=641;
        stopb<=0;
    end 
    else
    begin
        if (switch[3]==1&&win==0)
        begin
            if (bombshow==1)
            begin
                if (gobomb==0)
                begin
                    bom_bird_x<=10'd5;
                    bom_bird_y<=10'd425-move3;
                end
                else if (gobomb==1)
                begin
                    if (bom_bird_x<5+fly_Hbomb*60 && bom_bird_x<425 && bom_bird_y<425||(bom_bird_x==5 && bom_bird_y==425))
                    begin
                        bom_bird_x<=bom_bird_x+60;
                        bom_bird_y<=bom_bird_y-60;
                    end
                    else if ((bk1==0&&bom_bird_x==245&&bom_bird_y==305)||(ugly_pig1==0&&bom_bird_x==185&&bom_bird_y==305)||(ugly_pig2==0&&bom_bird_x==305&&bom_bird_y==305))
                    begin
                        bom_bird_x<=bom_bird_x+60;
                        bom_bird_y<=bom_bird_y+60;
                        stopb<=1;
                    end
                    else if (bom_bird_x>=5+fly_Hbomb*60 && bom_bird_x<425 && bom_bird_y<425 && stopb==0)
                    begin
                        bom_bird_x<=bom_bird_x+60;
                        bom_bird_y<=bom_bird_y+60; 
                    end
                    else
                    begin
                        bom_bird_x<=bom_bird_x;
                        bom_bird_y<=bom_bird_y;
                        stopb<=1;
                    end
                end
                else
                begin
                    bom_bird_x<=bom_bird_x;
                    bom_bird_y<=bom_bird_y;
                end
            end
        end//switch3end
    end//else rstend
end
always@(posedge pclk,negedge rst)
begin
    if(!rst)
    begin
            move0<=0;//angry1
            move01<=0;//angry2
            move1<=0;//speed1
            move2<=0;//leftright
            move11<=0;//speed2
            move21<=0;//leftright
            move3<=0;//bomb
            fly_H<=1;
            fly_H1<=1;
            fly_Hbomb<=1;
            go<=0;//向右射
            goup<=0;//向上射
            go1<=0;//向右射
            goup1<=0;//向上射
            goangry<=0;
            goangry1<=0;
            gobomb<=0;
            i<=0;
    end 
    else 
    begin
        if (switch[3]==0)
        begin
            if(S4==1&&debcnt==2500000&&angry_bird_y>10'd305&&switch[1]==1&&switch[0]==0&&move0<120)
            begin
                move0<=move0+10'd60;
            end 
            else if(S2==1&&debcnt==2500000&&angry_bird_y<10'd425&&switch[1]==1&&switch[0]==0&&move0>0)
            begin
                 move0<=move0-10'd60;
            end 
            else if(S4==1&&debcnt==2500000&&speed_bird_y>10'd305&&switch[1]==0&&switch[0]==1&&move1<120)
            begin
                move1<=move1+10'd60;
            end 
            else if(S2==1&&debcnt==2500000&&speed_bird_y<10'd425&&switch[1]==0&&switch[0]==1&&move1>0)
            begin
                 move1<=move1-10'd60;
            end 
            else if(S1==1&&debcnt==2500000&&switch[1]==0&&switch[0]==1)
            begin
                go<=1;
            end
            else if(S1==1&&debcnt==2500000&&switch[1]==1&&switch[0]==0&&fly_H>0)
            begin
                goangry<=1;
            end
            else if((S0==1||S3==1)&&debcnt==2500000&&switch[1]==1&&switch[0]==0&&goangry==0)
            begin
                if (S0==1&&fly_H<5)
                begin
                    fly_H<=fly_H+1;
                end
                else if (S3==1&&fly_H>1)
                begin
                    fly_H<=fly_H-1;
                end
                else i<=0;
            end
            else
                move0<=move0;
        end//switch3end
        else
        begin
            if (speedshow==1&&S4==1&&move1<120&&move2==0&&debcnt==2500000&&goup==0)//updown
            begin
                move1<=move1+60;
            end
            else i<=0;
            if (speedshow==1&&S2==1&&move1>0&&move2==0&&debcnt==2500000&&goup==0)
            begin
                move1<=move1-60;
            end
            else i<=0;
            if (speedshow==1&&S0==1&&move1==0&&move2<120&&debcnt==2500000&&go==0)//leftright
            begin
                move2<=move2+60;
            end
            else i<=0;
            if (speedshow==1&&S3==1&&move1==0&&move2>0&&debcnt==2500000&&go==0)
            begin
                move2<=move2-60;
            end
            else i<=0;
            if (speedshow1==1&&S4==1&&move11<120&&move21==0&&debcnt==2500000&&goup1==0)//updown
            begin
                move11<=move11+60;
            end
            else i<=0;
            if (speedshow==1&&S2==1&&move11>0&&move21==0&&debcnt==2500000&&goup1==0)
            begin
                move11<=move11-60;
            end
            else i<=0;
            if (speedshow==1&&S0==1&&move11==0&&move21<120&&debcnt==2500000&&go1==0)//leftright
            begin
                move21<=move21+60;
            end
            else i<=0;
            if (speedshow==1&&S3==1&&move11==0&&move21>0&&debcnt==2500000&&go1==0)
            begin
                move21<=move21-60;
            end
            else i<=0;
            if (angryshow==1&&S4==1&&move0<120&&debcnt==2500000&&goangry==0)
            begin
                move0<=move0+60;
            end
            else i<=0;
            if (angryshow==1&&S2==1&&move0>0&&debcnt==2500000&&goangry==0)
            begin
                move0<=move0-60;
            end
            else i<=0;
            if (angryshow1==1&&S4==1&&move01<120&&debcnt==2500000&&goangry1==0)
            begin
                move01<=move01+60;
            end
            else i<=0;
            if (angryshow1==1&&S2==1&&move01>0&&debcnt==2500000&&goangry1==0)
            begin
                move01<=move01-60;
            end
            else i<=0;
            if (bombshow==1&&S4==1&&move3<120&&debcnt==2500000&&gobomb==0)
            begin
                move3<=move3+60;
            end
            else i<=0;
            if (bombshow==1&&S2==1&&move3>0&&debcnt==2500000&&gobomb==0)
            begin
                move3<=move3-60;
            end
            else i<=0;
            if (angryshow==1&&S1==1&&debcnt==2500000)
                goangry<=1;
            else i<=0;
            if (angryshow1==1&&S1==1&&debcnt==2500000)
                goangry1<=1;
            else i<=0;
            if (speedshow==1&&S1==1&&switch[2]==0&&debcnt==2500000)
            begin
                go<=1;
                goup<=0;
            end
            else i<=0;
            if (speedshow1==1&&S1==1&&switch[2]==0&&debcnt==2500000)
            begin
                go1<=1;
                goup1<=0;
            end
            else i<=0;
            if (speedshow==1&&S1==1&&switch[2]==1&&debcnt==2500000)
            begin
                goup<=1;
                go<=0;
            end
            else i<=0;
            if (speedshow1==1&&S1==1&&switch[2]==1&&debcnt==2500000)
            begin
                goup1<=1;
                go1<=0;
            end
            else i<=0;
            if (bombshow==1&&S1==1&&debcnt==2500000)
                gobomb<=1;
            
            else i<=0;
            if((S0==1||S3==1)&&debcnt==2500000&&angryshow==1&&goangry==0)
            begin
                if (S0==1&&fly_H<5)
                begin
                    fly_H<=fly_H+1;
                end
                else if (S3==1&&fly_H>1)
                begin
                    fly_H<=fly_H-1;
                end
                else i<=0;
            end
            else i<=0;
            if((S0==1||S3==1)&&debcnt==2500000&&angryshow1==1&&goangry1==0)
            begin
                if (S0==1&&fly_H1<5)
                begin
                    fly_H1<=fly_H1+1;
                end
                else if (S3==1&&fly_H1>1)
                begin
                    fly_H1<=fly_H1-1;
                end
                else i<=0;
            end
            else i<=0;
            if((S0==1||S3==1)&&debcnt==2500000&&bombshow==1&&gobomb==0)
            begin
                if (S0==1&&fly_Hbomb<5)
                begin
                    fly_Hbomb<=fly_Hbomb+1;
                end
                else if (S3==1&&fly_Hbomb>1)
                begin
                    fly_Hbomb<=fly_Hbomb-1;
                end
                else i<=0;
            end
            else i<=0;
        end//else switch3end
     end//else rstend    
end

always @(posedge pclk,negedge rst) begin//////////////////////////////2Hz
if(!rst)
begin
counter_clk1 <= 0;
clk_temp1<=0;
end
    else begin
    if(counter_clk1 == 12500000) begin
    counter_clk1 <= 0;
    clk_temp1 <= ~clk_temp1;
    end
    else counter_clk1 <= counter_clk1 + 1;
end
end

always @(posedge pclk,negedge rst) begin//////////////////////////////4Hz
if(!rst)
begin
counter_clk2 <= 0;
clk_temp2<=0;
end
    else begin
    if(counter_clk2 == 6250000) begin
    counter_clk2 <= 0;
    clk_temp2 <= ~clk_temp2;
    end
    else counter_clk2 <= counter_clk2 + 1;
end
end
//////////////////////////////////////////////////384HZ
always @(posedge pclk,negedge rst) begin
if(!rst)
begin
counter_seven<=0;
clk_seven_temp<=0;
end
    else begin
    if(counter_seven == 55000) begin
    counter_seven <= 0;
    clk_seven_temp <= ~clk_seven_temp;
    end else counter_seven <= counter_seven + 1;
end
end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////七段顯示器
always@(posedge clk_seven_temp,negedge rst)
begin
    if(!rst)
    begin
        enable_L<=4'b1000;
        out_L<=0;
        enable_R<=0;
        out_R<=0;
        counter<=0;
        x<=0;
    end 
    else if(switch[3]==0)
    begin
        if(switch[3]==1)
        begin
            out_L<=7'b1101101;
        end 
        else
            out_L<=7'b0110000;
        case(counter)
        0:
        begin 
            enable_R<=4'b1000;
            case(fly_H)
            1:out_R<=7'b0110000;
            2:out_R<=7'b1101101;
            3:out_R<=7'b1111001;
            4:out_R<=7'b0110011;
            5:out_R<=7'b1011011;
            default:x<=0;
            endcase
            counter<=counter+1;
        end
        1:
        begin 
            enable_R<=4'b0100;
            if(goangry==1)
                out_R<=7'b1111110;
            else
                out_R<=7'b0110000;
            counter<=counter+1;
        end
        2:begin 
            enable_R<=4'b0010;
            if(go==1)
                out_R<=7'b1111110;
            else
                out_R<=7'b0110000;
            counter<=counter+1;
        end
        3:begin enable_R<=4'b0001;out_R<=7'b1111110;counter<=0;end
        default:x<=0;
        endcase
    end 
    else if(switch[3]==1)
    begin
        out_L<=7'b1101101;
        case(counter)
        0:
        begin 
            enable_R<=4'b1000;
            if(ryb==8'b00110101&&({switch[1],switch[0]}!=2'b00))
            begin
                if(switch[2]==0)
                begin
                    out_R<=7'b0001001;
                    counter<=counter+1;
                end
                else 
                begin
                    out_R<=7'b0010100;
                    counter<=counter+1;
                end
            end 
            else
            begin
            if(angryshow==1&&goangry==0)
                begin
                    case(fly_H)
                    1:out_R<=7'b0110000;
                    2:out_R<=7'b1101101;
                    3:out_R<=7'b1111001;
                    4:out_R<=7'b0110011;
                    5:out_R<=7'b1011011;
                    default:x<=0;
                    endcase
                    counter<=counter+1;
                end
            
            else if(angryshow1==1&&goangry1==0)
            begin
                    case(fly_H1)
                    1:out_R<=7'b0110000;
                    2:out_R<=7'b1101101;
                    3:out_R<=7'b1111001;
                    4:out_R<=7'b0110011;
                    5:out_R<=7'b1011011;
                    default:x<=0;
                    endcase
                    counter<=counter+1;
            end
            else if(bombshow==1&&gobomb==0)
                begin
                        case(fly_Hbomb)
                        1:out_R<=7'b0110000;
                        2:out_R<=7'b1101101;
                        3:out_R<=7'b1111001;
                        4:out_R<=7'b0110011;
                        5:out_R<=7'b1011011;
                        default:x<=0;
                        endcase
                        counter<=counter+1;
                end 
                else 
                begin
                    out_R<=7'b0110000;
                    counter<=counter+1;
                end
            end
        end
        1://///憤怒鳥
        begin 
            enable_R<=4'b0100;
            case({switch[1],switch[0]})
            2'b10:
            begin
                if(goangry==0&&goangry1==0)
                begin
                    out_R<=7'b1101101;
                    counter<=counter+1;
                end
                else if(goangry==1&&goangry1==0)
                begin
                    out_R<=7'b0110000;
                    counter<=counter+1;
                end
                else
                begin
                    out_R<=7'b1111110;
                    counter<=counter+1;
                end
            end
            2'b01:
            begin
                if(goangry==0)
                begin
                    out_R<=7'b0110000;
                    counter<=counter+1;
                end
                else
                begin
                    out_R<=7'b1111110;
                    counter<=counter+1;
                end
            end
            2'b00:out_R<=7'b1111110;
            default:x<=0;
            endcase
            counter<=counter+1;
        end
        2:begin 
            enable_R<=4'b0010;
            case({switch[1],switch[0]})
            2'b10:
            begin
                if(go==0&&goup==0&&go1==0&&goup1==0)
                begin
                    out_R<=7'b1101101;
                    counter<=counter+1;
                end
                else if((go==1||goup==1)&&((go1==0&&goup1==0)))
                begin
                    out_R<=7'b0110000;
                    counter<=counter+1;
                end
                else
                begin
                    out_R<=7'b1111110;
                    counter<=counter+1;
                end
            end
            2'b01:
            begin
                if((go==0&&goup==0))
                begin
                    out_R<=7'b0110000;
                    counter<=counter+1;
                end
                else
                begin
                    out_R<=7'b1111110;
                    counter<=counter+1;
                end
            end
            2'b00:begin out_R<=7'b1111110;counter<=counter+1;end
            default:x<=0;
            endcase
        end
        3:
        begin 
            enable_R<=4'b0001;
            if(gobomb==1)
            begin
                out_R<=7'b1111110;
                counter<=0;
            end
            else
            begin
                out_R<=7'b0110000;
                counter<=0;
            end
        end
        default:x<=0;
        endcase
    end 
end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////LED

always@(posedge clk2,negedge rst)
begin
    if(!rst)
    begin
    LED<=0;
    counter_LED<=0;
    stop<=0;
    y<=0;
    end 
    else 
    begin
        if(switch[3]==0)
        begin 
            if(go==1&&goangry==1)
            begin
                if(angry_bird_x==305&&angry_bird_y==365&&speed_bird_x==425&&speed_bird_y==425&&go==1&&goangry==1)
                begin               
                    case(counter_LED)
                    0:begin LED[15]<=1;LED[14]<=1;LED[11]<=1;LED[10]<=1;LED[5]<=1;LED[4]<=1;LED[1]<=1;LED[0]<=1;LED[13]<=0;LED[12]<=0;LED[9]<=0;LED[8]<=0;LED[7]<=0;LED[6]<=0;LED[2]<=0;LED[3]<=0;counter_LED<=1;end
                    1:begin LED[13]<=1;LED[12]<=1;LED[9]<=1;LED[8]<=1;LED[7]<=1;LED[6]<=1;LED[2]<=1;LED[3]<=1;LED[15]<=0;LED[14]<=0;LED[11]<=0;LED[10]<=0;LED[5]<=0;LED[4]<=0;LED[1]<=0;LED[0]<=0;counter_LED<=0;end
                    default:y<=0;
                    endcase
                end 
                else if(go==1&&goangry==1&&speed_bird_x==425&&stop==0&&touch==1)
                begin
                    case(counter_LED)
                    0:begin LED<=0;counter_LED<=counter_LED+1;end
                    1:begin LED[15]<=1; LED[8]<=1; LED[7]<=1; LED[0]<=1;counter_LED<=counter_LED+1;end
                    2:begin LED[14]<=1;LED[9]<=1; LED[6]<=1;  LED[1]<=1;LED[15]<=0; LED[8]<=0; LED[7]<=0; LED[0]<=0; counter_LED<=counter_LED+1; end
                    3:begin LED[13]<=1;LED[10]<=1; LED[5]<=1; LED[2]<=1;LED[14]<=0;LED[9]<=0; LED[6]<=0; LED[1]<=0;  counter_LED<=counter_LED+1;end
                    4:begin LED[12]<=1;LED[11]<=1; LED[4]<=1; LED[3]<=1;LED[13]<=0;LED[10]<=0; LED[5]<=0; LED[2]<=0; counter_LED<=counter_LED+1;end
                    5:begin LED[13]<=1;LED[10]<=1; LED[5]<=1; LED[2]<=1;LED[12]<=0;LED[11]<=0; LED[4]<=0; LED[3]<=0; counter_LED<=counter_LED+1;end
                    6:begin LED[14]<=1;LED[9]<=1; LED[6]<=1;  LED[1]<=1;LED[13]<=0;LED[10]<=0; LED[5]<=0; LED[2]<=0; counter_LED<=counter_LED+1;end
                    7:begin LED[15]<=1; LED[8]<=1; LED[7]<=1; LED[0]<=1;LED[14]<=0;LED[9]<=0; LED[6]<=0; LED[1]<=0;  counter_LED<=counter_LED+1;end
                    8:begin LED<=0; counter_LED<=0;stop<=1;end
                    default:y<=0;
                    endcase   
                end 
                else
                    y<=0;
            end  
        end else if(switch[3]==1)
        begin
            if(win==1)
            begin              
                    case(counter_LED)
                    0:begin LED[15]<=1;LED[14]<=1;LED[11]<=1;LED[10]<=1;LED[5]<=1;LED[4]<=1;LED[1]<=1;LED[0]<=1;LED[13]<=0;LED[12]<=0;LED[9]<=0;LED[8]<=0;LED[7]<=0;LED[6]<=0;LED[2]<=0;LED[3]<=0;counter_LED<=1;end
                    1:begin LED[13]<=1;LED[12]<=1;LED[9]<=1;LED[8]<=1;LED[7]<=1;LED[6]<=1;LED[2]<=1;LED[3]<=1;LED[15]<=0;LED[14]<=0;LED[11]<=0;LED[10]<=0;LED[5]<=0;LED[4]<=0;LED[1]<=0;LED[0]<=0;counter_LED<=0;end
                    default:y<=0;
                    endcase
            end 
            else if(win==0&&({switch[1],switch[0]}==2'b00)&&stopb==1&&stop==0)
                begin
                    case(counter_LED)
                    0:begin LED<=0;counter_LED<=counter_LED+1;end
                    1:begin LED[15]<=1; LED[8]<=1; LED[7]<=1; LED[0]<=1;counter_LED<=counter_LED+1;end
                    2:begin LED[14]<=1;LED[9]<=1; LED[6]<=1;  LED[1]<=1;LED[15]<=0; LED[8]<=0; LED[7]<=0; LED[0]<=0; counter_LED<=counter_LED+1; end
                    3:begin LED[13]<=1;LED[10]<=1; LED[5]<=1; LED[2]<=1;LED[14]<=0;LED[9]<=0; LED[6]<=0; LED[1]<=0;  counter_LED<=counter_LED+1;end
                    4:begin LED[12]<=1;LED[11]<=1; LED[4]<=1; LED[3]<=1;LED[13]<=0;LED[10]<=0; LED[5]<=0; LED[2]<=0; counter_LED<=counter_LED+1;end
                    5:begin LED[13]<=1;LED[10]<=1; LED[5]<=1; LED[2]<=1;LED[12]<=0;LED[11]<=0; LED[4]<=0; LED[3]<=0; counter_LED<=counter_LED+1;end
                    6:begin LED[14]<=1;LED[9]<=1; LED[6]<=1;  LED[1]<=1;LED[13]<=0;LED[10]<=0; LED[5]<=0; LED[2]<=0; counter_LED<=counter_LED+1;end
                    7:begin LED[15]<=1; LED[8]<=1; LED[7]<=1; LED[0]<=1;LED[14]<=0;LED[9]<=0; LED[6]<=0; LED[1]<=0;  counter_LED<=counter_LED+1;end
                    8:begin LED<=0; counter_LED<=0;stop<=1;end
                    default:y<=0;
                    endcase   
            end
            else if(win==0&&({switch[1],switch[0]}==2'b01)&&stopb==1&&stopa==1&&stops==1&&stop==0)
                begin
                    case(counter_LED)
                    0:begin LED<=0;counter_LED<=counter_LED+1;end
                    1:begin LED[15]<=1; LED[8]<=1; LED[7]<=1; LED[0]<=1;counter_LED<=counter_LED+1;end
                    2:begin LED[14]<=1;LED[9]<=1; LED[6]<=1;  LED[1]<=1;LED[15]<=0; LED[8]<=0; LED[7]<=0; LED[0]<=0; counter_LED<=counter_LED+1; end
                    3:begin LED[13]<=1;LED[10]<=1; LED[5]<=1; LED[2]<=1;LED[14]<=0;LED[9]<=0; LED[6]<=0; LED[1]<=0;  counter_LED<=counter_LED+1;end
                    4:begin LED[12]<=1;LED[11]<=1; LED[4]<=1; LED[3]<=1;LED[13]<=0;LED[10]<=0; LED[5]<=0; LED[2]<=0; counter_LED<=counter_LED+1;end
                    5:begin LED[13]<=1;LED[10]<=1; LED[5]<=1; LED[2]<=1;LED[12]<=0;LED[11]<=0; LED[4]<=0; LED[3]<=0; counter_LED<=counter_LED+1;end
                    6:begin LED[14]<=1;LED[9]<=1; LED[6]<=1;  LED[1]<=1;LED[13]<=0;LED[10]<=0; LED[5]<=0; LED[2]<=0; counter_LED<=counter_LED+1;end
                    7:begin LED[15]<=1; LED[8]<=1; LED[7]<=1; LED[0]<=1;LED[14]<=0;LED[9]<=0; LED[6]<=0; LED[1]<=0;  counter_LED<=counter_LED+1;end
                    8:begin LED<=0; counter_LED<=0;stop<=1;end
                    default:y<=0;
                    endcase   
            end
            else if(win==0&&({switch[1],switch[0]}==2'b10)&&stopb==1&&stopa==1&&stops==1&&stops1==1&&stopa1==1&&stop==0)
            begin
                    case(counter_LED)
                    0:begin LED<=0;counter_LED<=counter_LED+1;end
                    1:begin LED[15]<=1; LED[8]<=1; LED[7]<=1; LED[0]<=1;counter_LED<=counter_LED+1;end
                    2:begin LED[14]<=1;LED[9]<=1; LED[6]<=1;  LED[1]<=1;LED[15]<=0; LED[8]<=0; LED[7]<=0; LED[0]<=0; counter_LED<=counter_LED+1; end
                    3:begin LED[13]<=1;LED[10]<=1; LED[5]<=1; LED[2]<=1;LED[14]<=0;LED[9]<=0; LED[6]<=0; LED[1]<=0;  counter_LED<=counter_LED+1;end
                    4:begin LED[12]<=1;LED[11]<=1; LED[4]<=1; LED[3]<=1;LED[13]<=0;LED[10]<=0; LED[5]<=0; LED[2]<=0; counter_LED<=counter_LED+1;end
                    5:begin LED[13]<=1;LED[10]<=1; LED[5]<=1; LED[2]<=1;LED[12]<=0;LED[11]<=0; LED[4]<=0; LED[3]<=0; counter_LED<=counter_LED+1;end
                    6:begin LED[14]<=1;LED[9]<=1; LED[6]<=1;  LED[1]<=1;LED[13]<=0;LED[10]<=0; LED[5]<=0; LED[2]<=0; counter_LED<=counter_LED+1;end
                    7:begin LED[15]<=1; LED[8]<=1; LED[7]<=1; LED[0]<=1;LED[14]<=0;LED[9]<=0; LED[6]<=0; LED[1]<=0;  counter_LED<=counter_LED+1;end
                    8:begin LED<=0; counter_LED<=0;stop<=1;end
                    default:y<=0;
                    endcase   
            end
            else
                    y<=0;
        end
        else
            LED<=0;
    end
end
 ////////////////////////////////////////////////////////////////////////////////判斷clk
always@(posedge pclk,negedge rst)
begin
    if(!rst)
    clk2<=0;
    else
    begin
         if(go==1&&goangry==1&&angry_bird_x!=305&&angry_bird_y!=365&&speed_bird_x!=425&&speed_bird_y!=425)
            clk2<=clk_temp2;
         else
            clk2<=clk_temp1;
    end
end
endmodule

module SyncGeneration(pclk, reset, hSync, vSync, dataValid, hDataCnt, vDataCnt);
   input        pclk;
   input        reset;
   output       hSync;
   output       vSync;
   output       dataValid;
   output [9:0] hDataCnt;
   output [9:0] vDataCnt ;
 

   parameter    H_SP_END = 96;
   parameter    H_BP_END = 144;
   parameter    H_FP_START = 785;
   parameter    H_TOTAL = 800;
   
   parameter    V_SP_END = 2;
   parameter    V_BP_END = 35;
   parameter    V_FP_START = 516;
   parameter    V_TOTAL = 525;

   reg [9:0]    x_cnt,y_cnt;
   wire         h_valid,v_valid;
     
   always @(posedge reset or posedge pclk) begin
      if (reset)
         x_cnt <= 10'd1;
      else begin
         if (x_cnt == H_TOTAL)
            x_cnt <= 10'd1;
         else
            x_cnt <= x_cnt + 1;
      end
   end
   
   always @(posedge pclk or posedge reset) begin
      if (reset)
         y_cnt <= 10'd1;
      else begin
         if (y_cnt == V_TOTAL & x_cnt == H_TOTAL)
            y_cnt <= 1;
         else if (x_cnt == H_TOTAL)
            y_cnt <= y_cnt + 1;
         else y_cnt<=y_cnt;
      end
   end
   
   assign hSync = ((x_cnt > H_SP_END)) ? 1'b1 : 1'b0;
   assign vSync = ((y_cnt > V_SP_END)) ? 1'b1 : 1'b0;
   
   // Check P7 for horizontal timing   
   assign h_valid = ((x_cnt > H_BP_END) & (x_cnt <= H_FP_START)) ? 1'b1 : 1'b0;
   // Check P9 for vertical timing
   assign v_valid = ((y_cnt > V_BP_END) & (y_cnt <= V_FP_START)) ? 1'b1 : 1'b0;
   
   assign dataValid = ((h_valid == 1'b1) & (v_valid == 1'b1)) ? 1'b1 :  1'b0;
   
   // hDataCnt from 1 if h_valid==1
   assign hDataCnt = ((h_valid == 1'b1)) ? x_cnt - H_BP_END : 10'b0;
   // vDataCnt from 1 if v_valid==1
   assign vDataCnt = ((v_valid == 1'b1)) ? y_cnt - V_BP_END : 10'b0; 
            
   
endmodule
