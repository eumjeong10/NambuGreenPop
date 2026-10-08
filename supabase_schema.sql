-- =================================================================
-- 남부그린팝 월간 근무표 자동 편성 시스템 - Supabase SQL Schema
-- =================================================================
-- 이 스크립트를 Supabase Dashboard -> SQL Editor에 붙여넣고 [Run]을 누르면
-- 모든 테이블 생성, Row Level Security(RLS) 정책 설정, 초기 18인 기본 참여자 데이터 삽입이 완료됩니다.

-- 1. 참여자 테이블 (participants)
CREATE TABLE IF NOT EXISTS participants (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    shift TEXT NOT NULL CHECK (shift IN ('오전', '오후')),
    days JSONB NOT NULL DEFAULT '[]'::jsonb,
    sale TEXT NOT NULL DEFAULT '가능' CHECK (sale IN ('선호', '가능', '불가')),
    produce TEXT NOT NULL DEFAULT '가능' CHECK (produce IN ('선호', '가능', '불가')),
    machine TEXT NOT NULL DEFAULT '불가' CHECK (machine IN ('선호', '가능', '불가')),
    prev_shortage INTEGER NOT NULL DEFAULT 0,
    prev_priority_used INTEGER NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW())
);

-- 2. 월간 근무표 테이블 (monthly_schedules)
CREATE TABLE IF NOT EXISTS monthly_schedules (
    ym TEXT PRIMARY KEY, -- 'YYYY-MM'
    schedule JSONB NOT NULL DEFAULT '{}'::jsonb,
    metadata JSONB NOT NULL DEFAULT '{"status": "draft"}'::jsonb,
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW())
);

-- 3. 월별 설정 테이블 (공휴일, 참여자별 불가일) (monthly_settings)
CREATE TABLE IF NOT EXISTS monthly_settings (
    ym TEXT PRIMARY KEY, -- 'YYYY-MM'
    holidays JSONB NOT NULL DEFAULT '{}'::jsonb,
    unavailable JSONB NOT NULL DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW())
);

-- 4. 변경기록 대장 테이블 (change_history)
CREATE TABLE IF NOT EXISTS change_history (
    id TEXT PRIMARY KEY,
    ym TEXT NOT NULL,
    timestamp TEXT NOT NULL,
    type TEXT NOT NULL,
    person_id TEXT,
    person_name TEXT,
    detail TEXT,
    reason TEXT,
    memo TEXT,
    manager TEXT,
    old_date TEXT,
    new_date TEXT,
    old_role TEXT,
    new_role TEXT,
    substitute_id TEXT,
    substitute_name TEXT,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW())
);

-- 5. 시스템 전역 설정 테이블 (app_settings)
CREATE TABLE IF NOT EXISTS app_settings (
    key TEXT PRIMARY KEY,
    value JSONB NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW())
);

-- =================================================================
-- RLS (Row Level Security) 설정
-- 웹 브라우저 클라이언트(anon key)에서 직접 읽기/쓰기를 허용합니다.
-- =================================================================
ALTER TABLE participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE monthly_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE monthly_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE change_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;

-- 정책 생성 (기존 정책이 없을 경우에만 생성되도록 처리)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow public read/write on participants') THEN
        CREATE POLICY "Allow public read/write on participants" ON participants FOR ALL USING (true) WITH CHECK (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow public read/write on monthly_schedules') THEN
        CREATE POLICY "Allow public read/write on monthly_schedules" ON monthly_schedules FOR ALL USING (true) WITH CHECK (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow public read/write on monthly_settings') THEN
        CREATE POLICY "Allow public read/write on monthly_settings" ON monthly_settings FOR ALL USING (true) WITH CHECK (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow public read/write on change_history') THEN
        CREATE POLICY "Allow public read/write on change_history" ON change_history FOR ALL USING (true) WITH CHECK (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow public read/write on app_settings') THEN
        CREATE POLICY "Allow public read/write on app_settings" ON app_settings FOR ALL USING (true) WITH CHECK (true);
    END IF;
END $$;

-- =================================================================
-- 초기 기본 18인 참여자 데이터 시드 (초기 1회 자동 생성)
-- =================================================================
INSERT INTO participants (id, name, shift, days, sale, produce, machine, prev_shortage, prev_priority_used)
VALUES
    ('P01', '김순자', '오전', '["월", "화", "목"]'::jsonb, '선호', '불가', '불가', 0, 0),
    ('P02', '이영희', '오전', '["화", "수", "금"]'::jsonb, '선호', '불가', '불가', 0, 0),
    ('P03', '박정숙', '오전', '["월", "수", "목"]'::jsonb, '선호', '불가', '불가', 0, 0),
    ('P04', '최옥순', '오전', '["화", "목", "금"]'::jsonb, '선호', '불가', '불가', 0, 0),
    ('P05', '정명자', '오전', '["월", "수", "금"]'::jsonb, '선호', '불가', '불가', 0, 0),
    ('P06', '강철수', '오후', '["월", "화", "수", "목"]'::jsonb, '가능', '가능', '선호', 0, 0),
    ('P07', '조기계', '오후', '["월", "화", "목", "금"]'::jsonb, '가능', '선호', '가능', 0, 0),
    ('P08', '윤기술', '오후', '["화", "수", "목"]'::jsonb, '불가', '선호', '선호', 0, 0),
    ('P09', '장영자', '오후', '["월", "화", "금"]'::jsonb, '선호', '가능', '불가', 0, 0),
    ('P10', '임순희', '오후', '["수", "목", "금"]'::jsonb, '선호', '가능', '불가', 0, 0),
    ('P11', '한숙자', '오후', '["월", "수", "목"]'::jsonb, '가능', '선호', '불가', 0, 0),
    ('P12', '오경자', '오후', '["화", "수", "목"]'::jsonb, '가능', '선호', '불가', 0, 0),
    ('P13', '서봉수', '오후', '["월", "화", "수"]'::jsonb, '가능', '선호', '불가', 0, 0),
    ('P14', '배점순', '오후', '["화", "목", "금"]'::jsonb, '선호', '선호', '불가', 0, 0),
    ('P15', '백만석', '오후', '["월", "수", "목"]'::jsonb, '가능', '선호', '가능', 0, 0),
    ('P16', '권복례', '오후', '["화", "수", "금"]'::jsonb, '선호', '선호', '불가', 0, 0),
    ('P17', '신현자', '오후', '["월", "목", "금"]'::jsonb, '선호', '선호', '불가', 0, 0),
    ('P18', '황보선', '오후', '["월", "화", "목"]'::jsonb, '선호', '선호', '불가', 0, 0)
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    shift = EXCLUDED.shift,
    days = EXCLUDED.days,
    sale = EXCLUDED.sale,
    produce = EXCLUDED.produce,
    machine = EXCLUDED.machine;
