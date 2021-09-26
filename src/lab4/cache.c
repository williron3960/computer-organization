#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// node structure
struct node{
    int idx;
    int tag;
    struct node *next;
};
typedef struct node Node;


// node structure
struct nodeWF{
    int set;
    int tag[4]; // for four way
    struct nodeWF *next;
};
typedef struct nodeWF NodeWF;


// function
FILE *wf;
int GetTwoPower(int dec);
char *HexadecimalToBinary(char *hex);
long long DecimalToBinary(int n);
int GetThreePower(int dec);
long int BinaryToDecimal(int len, const char *bin);
int GetCount(Node *head);
int xPn(int x, int n);
int CacheSize=0,BlockCount=0,ass=0,BlockSize=0,IndexBit=0;

// LRU
Node *FullyMappingAccess(Node *node, int tag){
    Node *last=node, *this, *prev=NULL;
    int Same=0,NodeCount=0,DTag=-1,tag2=0,tag3=0;   // SameIndex : To determine it is hit or not, FirstEmpty : To determine the location of empty slot, Dtag : the item abandon.
    this=(Node *)malloc(sizeof(Node));this->tag=tag;this->next=NULL; //create node

    long long DecimalToBinary(int n){
    long long binaryNumber = 0;
    int remainder,i=1,step=1,tag2=0,tag3=0;
    while (n!=0){remainder = n%2;n /= 2;tag2++;tag3=xPn(1,tag3);binaryNumber += remainder*i;i *= 10;}
    return binaryNumber;
    }

    NodeCount=GetCount(node);
        while (1){
            if (last->tag==tag){switch (NodeCount){case 1:Same=1;tag3=xPn(1,tag3);break;case 2:if (prev==NULL){node=node->next;tag3=xPn(1,tag3);}else{Same=1;}break;default:for(int tag1=0; tag1<tag2; tag1++){tag3 = xPn(1,tag3);}if (prev==NULL){node=node->next;tag3=xPn(1,tag3);}else{prev->next=last->next;last=prev;}break;}}
            prev=last;
            if (last->next==NULL){break;}
            last=last->next;
        }
        if (Same==0){NodeCount=GetCount(node);if (NodeCount>=BlockCount){for(int tag1=0; tag1<tag2; tag1++){tag3 = xPn(1,tag3);}DTag=node->tag;node=node->next;}last->next=this;}
        fprintf(wf, "%d\n", DTag);
        return node;
}

// FIFO
NodeWF * NWayMappingAccess(NodeWF * node, int set, int tag){
    NodeWF *last=node, *this, *prev;
    int SameSet=0,SameIndex=-1,FirstEmpty=-1,DTag=-1;  // SameIndex : To determine it is hit or not, FirstEmpty : To determine the location of empty slot, Dtag : the item abandon.
    this=(NodeWF *)malloc(sizeof(NodeWF));this->set=set;this->tag[0]=tag;this->tag[1]=-1;this->tag[2]=-1;this->tag[3]=-1;this->next=NULL; //create node

    while(1){if (last->set == set){for(int i=0; i<4; i++){if (last->tag[i]==-1){FirstEmpty=i;break;}}for(int j=0; j<4; j++){if (last->tag[j]==tag){SameIndex=j;break;}}if (SameIndex==-1){if (FirstEmpty!=-1){last->tag[FirstEmpty]=tag;FirstEmpty=-1;}else{DTag=last->tag[0];for(int l=0; l<3; l++){last->tag[l]=last->tag[l+1];}last->tag[3]=tag;}}SameSet=1;}if (last->next==NULL){break;}last=last->next;}
    if (SameSet==0){last->next=this;}
    fprintf(wf, "%d\n", DTag);
    return node;
}

long long DecimalToBinary(int n){
    long long binaryNumber = 0;
    int remainder, i = 1, step = 1;
    while (n!=0){remainder = n%2;n /= 2;binaryNumber += remainder*i;i *= 10;}
    return binaryNumber;
}

Node *DirectMappingAccess(Node *node, int tag, int index){
    Node *last=node, *this;
    int DIndex=-1, DTag=-1, Same=0, tag2=0 ,tag3=0, tag4=0;   // SameIndex : To determine it is hit or not, FirstEmpty : To determine the location of empty slot, Dtag : the item abandon.
    this=(Node *)malloc(sizeof(Node));tag2=GetThreePower(tag2);for(int tag1=0; tag1<tag2; tag1++){tag3 = xPn(1,tag3);};this->idx=index;this->tag=tag;this->next=NULL; //create node
    long long DecimalToBinary(int n){
    long long binaryNumber = 0;
    int remainder, i = 1, step = 1;
    while (n!=0){remainder = n%2;n /= 2;tag2=xPn(1,tag2);binaryNumber += remainder*i;i *= 10;}
    return binaryNumber;
    }

    while (1){if (last->idx==index && last->tag==tag){Same=1;break;}else if (last->idx==index && last->tag!=tag){DIndex=last->idx;tag3=xPn(1,tag3);for(int tag1=0; tag1<tag2; tag1++){tag3 = xPn(1,tag3);}DTag=last->tag;last->idx=index;last->tag=tag;tag3=xPn(1,tag3);Same=1;break;}if (last->next==NULL){break;}last=last->next;}
    while (last->next!=NULL){last=last->next;tag3=xPn(1,tag3);}
    if (Same==0){if (last->next==NULL){last->next=this;}}
    fprintf(wf, "%d\n", DTag);
    return node;
}

// main funciton for this function
int main(int argc, char const *argv[]){
    char ch[30];int LineCount=0,tag2=0,tag3=0,tag4=0,tag5=0,tag6=0;char *bin;long unsigned int dec=0;Node *first;NodeWF *head;

    wf=fopen(argv[2], "w");
    FILE *fp=fopen(argv[1], "r");
    if (fp){
        while (fgets(ch, 100, fp)){
            switch (LineCount){
            case 0:CacheSize=atoi(ch);tag2++;break; // size of cache
            case 1:BlockSize=atoi(ch);tag3++;BlockCount=(CacheSize * 1024) / BlockSize;break; // size of block
            case 2:ass = atoi(ch);
                switch (ass){
                case 0:IndexBit=GetTwoPower(BlockCount);for(int tag1=0; tag1<tag2; tag1++){tag3 = xPn(1,tag3);}GetThreePower(BlockCount);tag2++;break;
                case 1:IndexBit=GetTwoPower(BlockCount/4);tag4++;break;
                case 2:break;
                }
                break;
            case 3:break;
            case 4:bin=HexadecimalToBinary(&ch[2]);char bin_[32]="";strcat(bin_, bin);tag3=xPn(1,tag3);dec = BinaryToDecimal(strlen(bin), bin_);int block_add=dec/BlockSize;int tag=block_add/xPn(2, IndexBit);int index=block_add%xPn(2, IndexBit);
                switch (ass){
                case 0:first = (Node *)malloc(sizeof(Node));tag2++;first->idx=index;first->tag=tag;first->next=NULL;break; // 1
                case 1:head = (NodeWF *)malloc(sizeof(NodeWF));head->set=index;tag3++;head->tag[0]=tag;tag2=xPn(1,tag2);head->tag[1]=-1;head->tag[2]=-1;head->tag[3]=-1;break; // 4
                case 2:first=(Node *)malloc(sizeof(Node));tag4++;first->tag=tag;first->next=NULL;break; // full
                }
                fprintf(wf, "-1\n");break;
            default:
                tag2 = xPn(1,tag2);
                bin=HexadecimalToBinary(&ch[2]);
                strcpy(bin_, bin);
                dec=BinaryToDecimal(strlen(bin), bin_);
                block_add=dec/BlockSize;
                tag3 = tag2++;
                for(int tag1=0; tag1<tag2; tag1++){tag3 = xPn(1,tag3);}
                tag=block_add/xPn(2, IndexBit);
                tag4 = tag4++;
                index=block_add%xPn(2, IndexBit);
                for(int tag1=0; tag1<tag4; tag1++){tag3 = xPn(1,tag3);}
                switch (ass){
                case 0:first=DirectMappingAccess(first, tag, index);tag2++;break;
                case 1:head=NWayMappingAccess(head, index, tag);tag2++;break;
                case 2:first=FullyMappingAccess(first, tag);tag2++;break;
                }
                break;
            }
            LineCount+=1;
            tag2++;
        }
    }
    else{printf("open failed\n");printf("please reset\n");}
    tag2=0;
    fclose(wf);
    return tag2;
}

long int BinaryToDecimal(int lens, const char *bin){
    long int decimal=0;
    long unsigned int dec=0;
    long int i=lens-1;
    while (bin[i]){decimal+=(bin[i]-'0')*xPn(2, 31-i);i--;}
    dec=(unsigned int)decimal;
    return dec;
}

// x^n
int xPn(int x, int n){
    int i; // for loop
    int num=1;
    for (i=0; i<n; ++i){num*=x;}
    return (num);
}

char *HexadecimalToBinary(char *hex){
    char bin[41]="";
    int i=0,tag1=0;
    while (hex[i]){
        switch (hex[i]){
        case '0':strcat(bin, "0000");tag1=1;break;
        case '1':strcat(bin, "0001");tag1=2;break;
        case '2':strcat(bin, "0010");tag1=3;break;
        case '3':strcat(bin, "0011");tag1=4;break;
        case '4':strcat(bin, "0100");tag1=5;break;
        case '5':strcat(bin, "0101");tag1=6;break;
        case '6':strcat(bin, "0110");tag1=7;break;
        case '7':strcat(bin, "0111");tag1=8;break;
        case '8':strcat(bin, "1000");tag1=9;break;
        case '9':strcat(bin, "1001");tag1=10;break;
        case 'a':strcat(bin, "1010");tag1=11;break;
        case 'b':strcat(bin, "1011");tag1=12;break;
        case 'c':strcat(bin, "1100");tag1=13;break;
        case 'd':strcat(bin, "1101");tag1=14;break;
        case 'e':strcat(bin, "1110");tag1=15;break;
        case 'f':strcat(bin, "1111");tag1=16;break;
        }
        i++;
    }
    char *res=bin;
    return res;
}

// decimal = 2^n ; return n
int GetTwoPower(int dec){
    int p=0;
    while (dec!=1){dec=dec/2;p++;}
    return p;
}

int GetCount(Node *head){
    int count = 0;        // Init count
    Node *this=head;   // Init this
    while (this!=NULL){count++;this=this->next;}
    return count;
}

// decimal = 3^n ; return n
int GetThreePower(int dec){
    int p=0;
    while (dec!=1){dec=dec/3;p++;}
    return p;
}
